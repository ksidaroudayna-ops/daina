import { Component, OnInit, inject, signal } from '@angular/core';
import { HttpClient } from '@angular/common/http';

interface Task {
  id?: number;
  title: string;
  done: boolean;
}

@Component({
  selector: 'app-root',
  template: `
    <main>
      <h1>Task Manager</h1>

      <form (submit)="add($event)">
        <input
          [value]="newTitle()"
          (input)="newTitle.set($any($event.target).value)"
          placeholder="Nouvelle tâche"
        />
        <button type="submit">Ajouter</button>
      </form>

      @if (error()) {
        <p class="error">{{ error() }}</p>
      }

      <ul>
        @for (t of tasks(); track t.id) {
          <li>
            <input type="checkbox" [checked]="t.done" (change)="toggle(t)" />
            <span [class.done]="t.done">{{ t.title }}</span>
            <button type="button" (click)="remove(t)">Supprimer</button>
          </li>
        }
      </ul>

      @if (tasks().length === 0) {
        <p class="empty">Aucune tâche pour le moment.</p>
      }
    </main>
  `,
  styles: [
    `
      main { max-width: 560px; margin: 40px auto; font-family: system-ui, sans-serif; padding: 0 16px; }
      form { display: flex; gap: 8px; margin-bottom: 16px; }
      form input { flex: 1; padding: 8px; }
      button { padding: 8px 12px; cursor: pointer; }
      ul { list-style: none; padding: 0; }
      li { display: flex; align-items: center; gap: 10px; padding: 8px 0; border-bottom: 1px solid #ddd; }
      li span { flex: 1; }
      .done { text-decoration: line-through; color: #888; }
      .error { color: #b00020; }
      .empty { color: #777; }
    `,
  ],
})
export class TasksComponent implements OnInit {
  private http = inject(HttpClient);
  private api = 'http://localhost:8080/api/tasks';

  tasks = signal<Task[]>([]);
  newTitle = signal('');
  error = signal('');

  ngOnInit() {
    this.load();
  }

  load() {
    this.http.get<Task[]>(this.api).subscribe({
      next: (t) => {
        this.tasks.set(t);
        this.error.set('');
      },
      error: () =>
        this.error.set('Impossible de joindre le backend (http://localhost:8080). Est-il lancé ?'),
    });
  }

  add(event: Event) {
    event.preventDefault();
    const title = this.newTitle().trim();
    if (!title) return;
    this.http.post<Task>(this.api, { title, done: false }).subscribe(() => {
      this.newTitle.set('');
      this.load();
    });
  }

  toggle(t: Task) {
    this.http.put(`${this.api}/${t.id}`, { ...t, done: !t.done }).subscribe(() => this.load());
  }

  remove(t: Task) {
    this.http.delete(`${this.api}/${t.id}`).subscribe(() => this.load());
  }
}

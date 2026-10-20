import { bootstrapApplication } from '@angular/platform-browser';
import { provideHttpClient } from '@angular/common/http';
import { TasksComponent } from './app/tasks.component';

bootstrapApplication(TasksComponent, {
  providers: [provideHttpClient()],
}).catch((err) => console.error(err));

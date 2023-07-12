import { registerPlugin } from '@capacitor/core';

import type { CallingPlugin } from './definitions';

const Calling = registerPlugin<CallingPlugin>('Calling', {
  web: () => import('./web').then(m => new m.CallingWeb()),
});

export * from './definitions';
export { Calling };

import { WebPlugin } from '@capacitor/core';

import type { CallingPlugin } from './definitions';

export class CallingWeb extends WebPlugin implements CallingPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}

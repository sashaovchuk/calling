import { WebPlugin } from '@capacitor/core';

import type { CallingPlugin } from './definitions';

export class CallingWeb extends WebPlugin implements CallingPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    return options;
  }

  async getVoIPToken(): Promise<{ token: string; }> {
    return {
      token: 'Web token not work'
    }
  };

  async outcomingCall(_call: {username: string, video: boolean}): Promise<{ status: string; }> {
    return {
      status: 'accepted'
    }
  }

  async incomingCall(_call: {username: string, video: boolean}): Promise<{ status: string; }> {
    return {
      status: 'accepted'
    }
  }
}

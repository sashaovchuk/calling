export interface CallingPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;

  getVoIPToken(): Promise<{token: string}>;
  outcomingCall(call: {username: string, video: boolean}): Promise<{status: string}>
  incomingCall(call: {username: string, video: boolean}): Promise<{status: string}>
}

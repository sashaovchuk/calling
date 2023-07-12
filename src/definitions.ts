export interface CallingPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}

export interface Member {
  _id?: string;
  id: number;
  name: string;
  surname: string;
  sex: string;
  age: number;
  phone: string;
}

export type ModeType = 'read' | 'update' | 'create' | 'delete';

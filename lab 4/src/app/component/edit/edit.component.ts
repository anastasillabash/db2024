import {Component, EventEmitter, Output} from '@angular/core';
import {Member} from "../../model/model";
import {MemberService} from "../../member.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-edit-members',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './edit.component.html',
  styleUrl: './edit.component.css'
})
export class EditComponent {
  @Output() onSubmit = new EventEmitter<void>();

  newMember: Member = {
    id: 0,
    name: '',
    surname: '',
    sex: '',
    age: 0,
    phone: ''
  };
  saved_id: string = '';

  constructor(private memberService: MemberService) { }

  editMember(): void {
    this.memberService.updateMember(this.saved_id, this.newMember)
      .subscribe(member => {
        console.log('Member edited:', member);
        this.onSubmit.emit()
      });
  }
}

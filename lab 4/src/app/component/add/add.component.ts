import {Component, EventEmitter, Output} from '@angular/core';
import {Member} from "../../model/model";
import {MemberService} from "../../member.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-create-member',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './add.component.html',
  styleUrl: './add.component.css'
})
export class AddComponent {
  @Output() onSubmit: EventEmitter<void> = new EventEmitter();

  newMember: Member = {
    id: 0,
    name: '',
    surname: '',
    sex: '',
    age: 0,
    phone: ''
  };

  constructor(private memberService: MemberService) { }


  createMember(): void {
    this.memberService.createMember(this.newMember)
      .subscribe(member => {
        console.log('Member created:', member);
        this.onSubmit.emit()
      });
  }
}
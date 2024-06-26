import {Component, EventEmitter, Output} from '@angular/core';
import {Member} from "../../model/model";
import {MemberService} from "../../member.service";
import {FormsModule} from "@angular/forms";

@Component({
  selector: 'app-delete-members',
  standalone: true,
  imports: [
    FormsModule
  ],
  templateUrl: './delete.component.html',
  styleUrl: './delete.component.css'
})
export class DeleteComponent {
  @Output() onDelete: EventEmitter<Member> = new EventEmitter<Member>();
  deleteId: string = '';

  constructor(private memberService: MemberService) {
  }

  deleteMemberById(): void {
    if (this.deleteId) {
      this.memberService.deleteMember(this.deleteId)
        .subscribe(() => this.onDelete.emit());
      this.deleteId = '';
    }
  }
}

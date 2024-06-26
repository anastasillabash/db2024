import {Component, OnInit} from '@angular/core';
import {RouterOutlet} from '@angular/router';
import {NgbDropdownModule} from "@ng-bootstrap/ng-bootstrap";
import {Member, ModeType} from "./model/model";
import {NgSwitch, NgSwitchCase, NgSwitchDefault} from "@angular/common";
import {ReadComponent} from "./component/read/read.component";
import {DeleteComponent} from "./component/delete/delete.component";
import {MemberService} from "./member.service";
import {AddComponent} from "./component/add/add.component";
import {EditComponent} from "./component/edit/edit.component";

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, NgbDropdownModule, NgSwitch, NgSwitchCase, NgSwitchDefault, ReadComponent, DeleteComponent, AddComponent, EditComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit{
  title(title: any) {
    throw new Error('Method not implemented.');
  }
  members: Member[] = [];
  modeType: ModeType = 'read';

  constructor(private memberService: MemberService) {}

  ngOnInit(): void {
    this.getMembers();
  }

  getMembers(): void {
    this.memberService.getMembers()
      .subscribe(members => this.members = members);
  }

  switchMode(t: ModeType) {
    this.modeType = t;
  }

  isMode(t: ModeType) {
    return t === this.modeType;
  }

  reload() {
    this.getMembers()
  }
}

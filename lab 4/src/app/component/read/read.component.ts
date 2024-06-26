import { Component, Input, OnInit } from '@angular/core';
import {MemberService} from "../../member.service";
import {Member} from "../../model/model";
import {NgForOf} from "@angular/common";

@Component({
  selector: 'app-read-members',
  standalone: true,
  imports: [
    NgForOf
  ],
  templateUrl: './read.component.html',
  styleUrl: './read.component.css'
})
export class ReadComponent{
  @Input() data!: Member[];
}

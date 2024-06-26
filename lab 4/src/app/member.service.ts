import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import {catchError, Observable, throwError} from "rxjs";
import {Member} from "./model/model";

const API_BASE_URL = 'http://localhost:4000/api/members';

@Injectable({
    providedIn: 'root'
  })
  export class MemberService {
  
    constructor(private http: HttpClient) { }
  
    getMembers(): Observable<Member[]> {
      return this.http.get<Member[]>(API_BASE_URL)
        .pipe(
          catchError(this.handleError)
        );
    }
  
    getMember(id: string): Observable<Member> {
      return this.http.get<Member>(`${API_BASE_URL}/${id}`)
        .pipe(
          catchError(this.handleError)
        );
    }
  
    createMember(mem: Member): Observable<Member> {
      return this.http.post<Member>(API_BASE_URL, mem)
        .pipe(
          catchError(this.handleError)
        );
    }
  
    updateMember(id: string, mem: Member): Observable<Member> {
      return this.http.put<Member>(`${API_BASE_URL}/${id}`, mem)
        .pipe(
          catchError(this.handleError)
        );
    }
  
    deleteMember(id: string): Observable<any> {
      return this.http.delete<any>(`${API_BASE_URL}/${id}`)
        .pipe(
          catchError(this.handleError)
        );
    }
  
    private handleError(error: any) {
      console.error(error);
      return throwError('An error occurred');
    }
  }

/*
  MIT License

  Copyright © 2023 Alex Høffner

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
  and associated documentation files (the “Software”), to deal in the Software without
  restriction, including without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or
  substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import { Countries } from './forms/countries/Countries';

import { FormsPathMapping, FormsModule as FormsCoreModule, KeyMap, FormEvent, EventType, DatabaseConnection as Connection, FormProperties, UsernamePassword, Form, MouseMap } from 'forms42core';

@FormsPathMapping(
	[
		{class: Countries, path: "/forms/countries"}
	]
)

export class FormsModule extends FormsCoreModule
{

	public list:Minimized = null;
	public static DATABASE:Connection = null;

	private countries:KeyMap = new KeyMap({key: 'C', ctrl: true});

	constructor()
	{
		super();

		// Demo cutom tag
		FormProperties.TagLibrary.set("AppHeader",AppHeader);

		this.parse();
		this.list = new Minimized();

		this.updateKeyMap(keymap);

		Connection.TRXTIMEOUT = 240;
		Connection.CONNTIMEOUT = 120;

		FormsModule.DATABASE = new Connection();

		this.addEventListener(this.close,{type: EventType.Key, key: keymap.close});
		this.addEventListener(this.login,{type: EventType.Key, key: keymap.login});

		this.addEventListener(this.open,
		[
			{type:EventType.Key,key:this.countries}
		]);

		this.OpenURLForm();
	}

	private async open(event:FormEvent) : Promise<boolean>
	{
		if (event.key == this.countries)
			this.showform(Countries);

		return(true);
	}

	private logontrg:object = null;
	public async login() : Promise<boolean>
	{
		let usrpwd:Form = await this.showform(UsernamePassword);
		this.logontrg = this.addFormEventListener(usrpwd,this.onLogon,{type: EventType.OnCloseForm});
		return(true);
	}

	private async onLogon(event:FormEvent) : Promise<boolean>
	{
		let form:UsernamePassword = event.form as UsernamePassword;
		this.removeEventListener(this.logontrg);

		if (form.accepted && form.username && form.password)
		{
			if (!await FormsModule.DATABASE.connect(form.username,form.password))
				this.login();
		}

		return(true);
	}

}

export class keymap extends KeyMap
{
	public static close:KeyMap = new KeyMap({key: 'w', ctrl: true});
}

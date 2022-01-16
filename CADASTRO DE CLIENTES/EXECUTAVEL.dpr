program EXECUTAVEL;

uses
  Forms,
  _cadastro_cliente in '_cadastro_cliente.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

unit _cadastro_cliente;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBClient, Grids, DBGrids, StdCtrls, Mask, DBCtrls, Buttons,
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket,
  IdSSLOpenSSL, IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP,
  IdMessage;

type
  TForm1 = class(TForm)
    dts_clientes: TDataSource;
    tbl_clientes: TClientDataSet;
    dbg_clientes: TDBGrid;
    edt_nome: TDBEdit;
    edt_rg: TDBEdit;
    edt_cpf: TDBEdit;
    edt_telefone: TDBEdit;
    edt_email: TDBEdit;
    edt_cep: TDBEdit;
    edt_logradouro: TDBEdit;
    edt_numero: TDBEdit;
    edt_complemento: TDBEdit;
    edt_bairro: TDBEdit;
    edt_cidade: TDBEdit;
    cbo_estado: TDBComboBox;
    edt_pais: TDBEdit;
    NOME: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    btn_incluir: TBitBtn;
    btn_salvar: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    btn_fechar: TBitBtn;
    tbl_clientesNOME: TStringField;
    tbl_clientesIDENTIDADE: TStringField;
    tbl_clientesCPF: TStringField;
    tbl_clientesLOGRADOURO: TStringField;
    tbl_clientesNUMERO: TStringField;
    tbl_clientesCOMPLEMENTO: TStringField;
    tbl_clientesBAIRRO: TStringField;
    tbl_clientesCIDADE: TStringField;
    tbl_clientesESTADO: TStringField;
    tbl_clientesPAIS: TStringField;
    tbl_clientesTELEFONE: TStringField;
    tbl_clientesEMAIL: TStringField;
    tbl_clientesCEP: TStringField;
    IdSSLIOHandlerSocket1: TIdSSLIOHandlerSocket;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    procedure btn_fecharClick(Sender: TObject);
    procedure btn_incluirClick(Sender: TObject);
    procedure btn_salvarClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edt_nomeKeyPress(Sender: TObject; var Key: Char);
    procedure edt_rgKeyPress(Sender: TObject; var Key: Char);
    procedure edt_cpfKeyPress(Sender: TObject; var Key: Char);
    procedure edt_telefoneKeyPress(Sender: TObject; var Key: Char);
    procedure edt_emailKeyPress(Sender: TObject; var Key: Char);
    procedure edt_cepKeyPress(Sender: TObject; var Key: Char);
    procedure edt_logradouroKeyPress(Sender: TObject; var Key: Char);
    procedure edt_numeroKeyPress(Sender: TObject; var Key: Char);
    procedure edt_complementoKeyPress(Sender: TObject; var Key: Char);
    procedure edt_bairroKeyPress(Sender: TObject; var Key: Char);
    procedure edt_cidadeKeyPress(Sender: TObject; var Key: Char);
    procedure cbo_estadoKeyPress(Sender: TObject; var Key: Char);
    procedure edt_paisKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn_fecharClick(Sender: TObject);
begin
   if messagedlg('DESEJA SAIR?',mtconfirmation,[mbyes,mbno],0) = mryes then
      Application.Terminate;
end;

procedure TForm1.btn_incluirClick(Sender: TObject);
begin
   tbl_clientes.Append;
   edt_nome.SetFocus;
end;

procedure TForm1.btn_salvarClick(Sender: TObject);
var
  // objetos necess?rios para o funcionamento
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocket;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  CaminhoAnexo: string;
begin
   if Pos('@', edt_email.Text) > 1 then
      begin
               if length(edt_nome.Text) > 0 then
                  if length(edt_email.Text) > 0 then
                            begin
                               // gravando o registro.
                               tbl_clientes.Post;

                                showmessage('DADOS REGISTRADOS COM SUCESSO.'+#13+'ATEN??O'+#13+'OS DADOS SER?O ENVIADOS PARA O SEU E-MAIL!'+#13#13+'? IMPORTANTE QUE O SEU EMAIL ESTEJA CORRETO. AGUARDE A MENSAGEM DE CONFIRMA??O!');
                                       { enviando os dados para o email do usu?rio. }
                                         // instancia??o dos objetos
                                          IdSSLIOHandlerSocket := TIdSSLIOHandlerSocket.Create(Self);
                                          IdSMTP := TIdSMTP.Create(Self);
                                          IdMessage := TIdMessage.Create(Self);

                                          try
                                            // Configura??o do SSL
                                            IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23;
                                            IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;

                                            // Configura??o do SMTP
                                            IdSMTP.IOHandler := IdSSLIOHandlerSocket;
                                            IdSMTP.AuthenticationType := atLogin;

                                            IdSMTP.Host := 'smtp.gmail.com';
                                            IdSMTP.Username := 'cebolinha.chuveiro@gmail.com';
                                            IdSMTP.Password := 'cebola4321';
                                            IdSMTP.Port := 465;

                                            // Tentativa de conex?o e autentica??o
                                            try
                                              IdSMTP.Connect;
                                              IdSMTP.Authenticate;
                                            except
                                              on E:Exception do
                                              begin
                                                MessageDlg('Erro na conex?o e/ou autentica??o: ' +
                                                            E.Message, mtWarning, [mbOK], 0);
                                                Exit;
                                              end;
                                            end;

                                            // Configura??o da mensagem
                                            IdMessage.From.Address := 'cebolinha.chuveiro@gmail.com';
                                            IdMessage.From.Name := 'Heder';
                                            IdMessage.ReplyTo.EMailAddresses := IdMessage.From.Address;
                                            IdMessage.Recipients.EMailAddresses := edt_email.Text;
                                            IdMessage.Subject := 'INFO - DADOS CADASTRAIS';
                                            IdMessage.Body.Text := 'NOME       :'+edt_nome.Text+'  '+
                                                                   'IDENTIDADE :'+edt_rg.Text;

                                            tbl_clientes.SaveToFile('C:\' + edt_nome.Text + '.xml');
                                            //tbl_clientes.LoadFromFile('C:\'+ edt_nome.Text + '.xml');


                                            // Anexo da mensagem (opcional)
                                            CaminhoAnexo := 'C:\'+edt_nome.Text+'.xml';
                                            if FileExists(CaminhoAnexo) then
                                              TIdAttachment.Create(IdMessage.MessageParts, CaminhoAnexo);

                                            // Envio da mensagem
                                            try
                                              IdSMTP.Send(IdMessage);
                                              MessageDlg('OS DADOS FORAM ENVIADOS PARA O SEU E-MAIL. FAVOR, VERIFIQUE A SUA CAIXA DE E-MAIL.', mtInformation, [mbOK], 0);
                                            except
                                              On E:Exception do
                                                MessageDlg('Erro ao enviar a mensagem: ' +
                                                            E.Message, mtWarning, [mbOK], 0);
                                            end;
                                          finally
                                            // liberando os objetos da mem?ria.
                                            FreeAndNil(IdMessage);
                                            FreeAndNil(IdSSLIOHandlerSocket);
                                            FreeAndNil(IdSMTP);
                                          end;

                            end
                  else
                     begin
                        messagedlg('FAVOR, INFORME O E-MAIL.',mtwarning,[mbok],0);
                        edt_email.SetFocus;
                     end
               else
                  begin
                     messagedlg('FAVOR, INFORME O NOME DO CLIENTE QUE DESEJA CADASTRAR.',mtwarning,[mbok],0);
                     edt_nome.SetFocus;
                  end;
      end
   else
      begin
         messagedlg('O E-MAIL INFORMADO N?O ? V?LIDO. FAVOR, VERIFIQUE NOVAMENTE.',mtwarning,[mbok],0);
         edt_email.SetFocus;
      end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
   if not tbl_clientes.IsEmpty then
      begin
         if messagedlg('DESEJA EXCLUIR O CADASTRO DO CLIENTE '+edt_nome.Text+' ?',mtconfirmation,[mbyes,mbno],0) = mryes then
            tbl_clientes.Delete
      end
   else
      messagedlg('N?O H? CLIENTES PARA EXCLUIR.',mtwarning,[mbok],0);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
    tbl_clientes.Edit;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = vk_escape then
      btn_fechar.Click;
end;

procedure TForm1.edt_nomeKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_rg.SetFocus;
end;

procedure TForm1.edt_rgKeyPress(Sender: TObject; var Key: Char);
begin
      if key = #13 then
         edt_cpf.SetFocus;

end;

procedure TForm1.edt_cpfKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_telefone.SetFocus;

end;

procedure TForm1.edt_telefoneKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_email.SetFocus;

end;

procedure TForm1.edt_emailKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_cep.SetFocus;

end;

procedure TForm1.edt_cepKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_logradouro.SetFocus;

end;

procedure TForm1.edt_logradouroKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_numero.SetFocus;

end;

procedure TForm1.edt_numeroKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_complemento.SetFocus;

end;

procedure TForm1.edt_complementoKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_bairro.SetFocus;

end;

procedure TForm1.edt_bairroKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_cidade.SetFocus;

end;

procedure TForm1.edt_cidadeKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      cbo_estado.SetFocus;

end;

procedure TForm1.cbo_estadoKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      edt_pais.SetFocus;

end;

procedure TForm1.edt_paisKeyPress(Sender: TObject; var Key: Char);
begin
   if key = #13 then
      btn_salvar.Click

end;

end.

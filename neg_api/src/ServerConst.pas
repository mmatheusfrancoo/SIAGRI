unit ServerConst;

interface

resourcestring
  sPortInUse        = '- Erro: Porta %s j� est� em uso';
  sPortSet          = '- Porta configurada para %s';
  sServerRunning    = '- O servidor j� est� sendo executado';
  sStartingServer   = '- Iniciando HTTP Server na porta %d';
  sStoppingServer   = '- Parando Servidor';
  sServerStopped    = '- Servidor parado';
  sServerNotRunning = '- O servidor n�o est� sendo executado';
  sInvalidCommand   = '- Erro: comando inv�lido';
  sIndyVersion      = '- Indy Version: ';
  sActive           = '- Ativo: ';
  sPort             = '- Porta: ';
  sSessionID        = '- Identifica��o da sess�o CookieName: ';
  sCommands         = 'Insira um Comando: '                                            + slineBreak +
                      '--------------------------------------------------------------' + slineBreak +
                      '   - "start" para iniciar o servidor'                           + slineBreak +
                      '   - "stop" para parar o servidor'                              + slineBreak +
                      '   - "set port" para alterar a porta padr�o'                    + slineBreak +
                      '   - "status" para o status do servidor'                        + slineBreak +
                      '   - "help" para mostrar comandos'                              + slineBreak +
                      '   - "exit" para fechar o aplicativo'                           + slineBreak +
                      '--------------------------------------------------------------';

const
  cArrow               = '->';
  cCommandStart        = 'start';
  cCommandStop         = 'stop';
  cCommandStatus       = 'status';
  cCommandHelp         = 'help';
  cCommandSetPort      = 'set port';
  cCommandExit         = 'exit';
  cCommandConfig       = 'SeverDataSnap.ini';

  kChaveAcesso         = 'Plattinum';
  // SIM, N�O
  RESPOSTA_SIM         = 'Sim';
  RESPOSTA_NAO         = 'N�o';

implementation

end.

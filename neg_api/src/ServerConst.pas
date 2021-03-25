unit ServerConst;

interface

resourcestring
  sPortInUse        = '- Erro: Porta %s já está em uso';
  sPortSet          = '- Porta configurada para %s';
  sServerRunning    = '- O servidor já está sendo executado';
  sStartingServer   = '- Iniciando HTTP Server na porta %d';
  sStoppingServer   = '- Parando Servidor';
  sServerStopped    = '- Servidor parado';
  sServerNotRunning = '- O servidor não está sendo executado';
  sInvalidCommand   = '- Erro: comando inválido';
  sIndyVersion      = '- Indy Version: ';
  sActive           = '- Ativo: ';
  sPort             = '- Porta: ';
  sSessionID        = '- Identificação da sessão CookieName: ';
  sCommands         = 'Insira um Comando: '                                            + slineBreak +
                      '--------------------------------------------------------------' + slineBreak +
                      '   - "start" para iniciar o servidor'                           + slineBreak +
                      '   - "stop" para parar o servidor'                              + slineBreak +
                      '   - "set port" para alterar a porta padrão'                    + slineBreak +
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
  // SIM, NÃO
  RESPOSTA_SIM         = 'Sim';
  RESPOSTA_NAO         = 'Não';

implementation

end.

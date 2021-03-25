object DMPrincipal: TDMPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 378
  Width = 518
  object con: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\mathe\Documents\GitHub\SIAGRI\neg_app\data\SIA' +
        'GRI.FDB'
      'User_Name=SYSDBA'
      'Server=localhost'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 216
    Top = 72
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 224
    Top = 168
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 224
    Top = 224
  end
end

object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 329
  Width = 343
  object con: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\mathe\Documents\GitHub\SIAGRI\neg_app\data\SIA' +
        'GRI.FDB'
      'User_Name=SYSDBA'
      'Server=localhost'
      'Password=masterkey'
      'DriverID=FB')
    LoginPrompt = False
    Left = 40
    Top = 32
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    Left = 40
    Top = 160
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 40
    Top = 106
  end
end

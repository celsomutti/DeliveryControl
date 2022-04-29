object DM_Main: TDM_Main
  OldCreateOrder = False
  Height = 444
  Width = 649
  object RESTClient: TRESTClient
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    ContentType = 'application/x-www-form-urlencoded'
    Params = <
      item
        Name = 'entregador'
        Value = '36'
      end
      item
        Name = 'data'
        Value = '2020-06-25'
      end>
    RaiseExceptionOn500 = False
    Left = 40
    Top = 24
  end
  object RESTRequest: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'entregador'
        Value = '10046'
      end>
    Response = RESTResponse
    SynchronizedEvents = False
    Left = 40
    Top = 80
  end
  object RESTResponse: TRESTResponse
    Left = 40
    Top = 144
  end
  object RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter
    FieldDefs = <>
    Response = RESTResponse
    Left = 160
    Top = 24
  end
  object memTableExtrato: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 160
    Top = 72
    object memTableExtratoid_extrato: TWideStringField
      DisplayLabel = 'ID'
      FieldName = 'id_extrato'
      Size = 255
    end
    object memTableExtratodat_inicio: TWideStringField
      DisplayLabel = 'In'#237'cio'
      FieldName = 'dat_inicio'
      Size = 255
    end
    object memTableExtratodat_final: TWideStringField
      DisplayLabel = 'Final'
      FieldName = 'dat_final'
      Size = 255
    end
    object memTableExtratonum_ano: TWideStringField
      DisplayLabel = 'Ano'
      FieldName = 'num_ano'
      Size = 255
    end
    object memTableExtratonum_mes: TWideStringField
      DisplayLabel = 'M'#234's'
      FieldName = 'num_mes'
      Size = 255
    end
    object memTableExtratonum_quinzena: TWideStringField
      DisplayLabel = 'Quinzena'
      FieldName = 'num_quinzena'
      Size = 255
    end
    object memTableExtratocod_base: TWideStringField
      DisplayLabel = 'Base'
      FieldName = 'cod_base'
      Size = 255
    end
    object memTableExtratocod_entregador: TWideStringField
      DisplayLabel = 'Entregador'
      FieldName = 'cod_entregador'
      Size = 255
    end
    object memTableExtratonum_extrato: TWideStringField
      DisplayLabel = 'N'#186' Extrato'
      FieldName = 'num_extrato'
      Size = 255
    end
    object memTableExtratoval_verba: TWideStringField
      DisplayLabel = 'Verba Entregador'
      FieldName = 'val_verba'
      Size = 255
    end
    object memTableExtratoqtd_volumes: TWideStringField
      DisplayLabel = 'Volumes'
      FieldName = 'qtd_volumes'
      Size = 255
    end
    object memTableExtratoqtd_volumes_extra: TWideStringField
      DisplayLabel = 'Vol. Extra'
      FieldName = 'qtd_volumes_extra'
      Size = 255
    end
    object memTableExtratoval_volumes_extra: TWideStringField
      DisplayLabel = 'Val. Vol. Extra'
      FieldName = 'val_volumes_extra'
      Size = 255
    end
    object memTableExtratoqtd_entregas: TWideStringField
      DisplayLabel = 'Entregas'
      FieldName = 'qtd_entregas'
      Size = 255
    end
    object memTableExtratoqtd_atraso: TWideStringField
      DisplayLabel = 'Atraso'
      FieldName = 'qtd_atraso'
      Size = 255
    end
    object memTableExtratoval_performance: TWideStringField
      DisplayLabel = 'Performance'
      FieldName = 'val_performance'
      Size = 255
    end
    object memTableExtratoval_producao: TWideStringField
      DisplayLabel = 'Producao'
      FieldName = 'val_producao'
      Size = 255
    end
    object memTableExtratoval_creditos: TWideStringField
      DisplayLabel = 'Cr'#233'ditos'
      FieldName = 'val_creditos'
      Size = 255
    end
    object memTableExtratoval_debitos: TWideStringField
      DisplayLabel = 'D'#233'bitos'
      FieldName = 'val_debitos'
      Size = 255
    end
    object memTableExtratoval_extravios: TWideStringField
      DisplayLabel = 'Extravios'
      FieldName = 'val_extravios'
      Size = 255
    end
    object memTableExtratoval_total_expressa: TWideStringField
      DisplayLabel = 'Total'
      FieldName = 'val_total_expressa'
      Size = 255
    end
    object memTableExtratoval_total_empresa: TWideStringField
      DisplayLabel = 'Total Empresa'
      FieldName = 'val_total_empresa'
      Size = 255
    end
    object memTableExtratocod_cliente: TWideStringField
      DisplayLabel = 'Cliente'
      FieldName = 'cod_cliente'
      Size = 255
    end
    object memTableExtratodat_credito: TWideStringField
      DisplayLabel = 'Data Cr'#233'dito'
      FieldName = 'dat_credito'
      Size = 255
    end
    object memTableExtratodes_unique_key: TWideStringField
      DisplayLabel = 'UK'
      FieldName = 'des_unique_key'
      Size = 255
    end
  end
  object memTableDatasCreditos: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 160
    Top = 128
    object memTableDatasCreditosdat_credito: TWideStringField
      FieldName = 'dat_credito'
      Size = 255
    end
  end
  object memTableBoletos: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 160
    Top = 184
    object memTableBoletosid_boleto: TWideStringField
      FieldName = 'id_boleto'
      Size = 255
    end
    object memTableBoletosnum_extrato: TWideStringField
      FieldName = 'num_extrato'
      Size = 255
    end
    object memTableBoletosdat_credito: TWideStringField
      FieldName = 'dat_credito'
      Size = 255
    end
    object memTableBoletosnum_linha_boleto: TWideStringField
      FieldName = 'num_linha_boleto'
      Size = 255
    end
    object memTableBoletosval_boleto: TWideStringField
      FieldName = 'val_boleto'
      Size = 255
    end
    object memTableBoletoscod_expressa: TWideStringField
      FieldName = 'cod_expressa'
      Size = 255
    end
    object memTableBoletosdat_cadastro: TWideStringField
      FieldName = 'dat_cadastro'
      Size = 255
    end
    object memTableBoletosnom_usuario: TWideStringField
      FieldName = 'nom_usuario'
      Size = 255
    end
    object memTableBoletosdom_recebido: TWideStringField
      FieldName = 'dom_recebido'
      Size = 255
    end
  end
  object memTableEntregas: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 160
    Top = 240
    object memTableEntregascod_cliente: TStringField
      FieldName = 'cod_cliente'
      Size = 255
    end
    object memTableEntregascod_entregador: TWideStringField
      FieldName = 'cod_entregador'
      Size = 255
    end
    object memTableEntregasval_verba: TWideStringField
      FieldName = 'val_verba'
      Size = 255
    end
    object memTableEntregasqtd_entregas: TWideStringField
      FieldName = 'qtd_entregas'
      Size = 255
    end
    object memTableEntregasnum_extrato: TWideStringField
      FieldName = 'num_extrato'
      Size = 255
    end
    object memTableEntregasdes_tipo: TStringField
      FieldName = 'des_tipo'
      Size = 255
    end
  end
  object memTableExtravios: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 160
    Top = 296
    object memTableExtraviosdes_extravio: TWideStringField
      FieldName = 'des_extravio'
      Size = 255
    end
    object memTableExtraviosnum_nossonumero: TWideStringField
      FieldName = 'num_nossonumero'
      Size = 255
    end
    object memTableExtravioscod_entregador: TWideStringField
      FieldName = 'cod_entregador'
      Size = 255
    end
    object memTableExtraviosval_total: TWideStringField
      FieldName = 'val_total'
      Size = 255
    end
  end
  object memTableLancamentos: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired]
    UpdateOptions.CheckRequired = False
    StoreDefs = True
    Left = 160
    Top = 352
    object memTableLancamentosdes_lancamento: TWideStringField
      FieldName = 'des_lancamento'
      Size = 255
    end
    object memTableLancamentosdat_lancamento: TWideStringField
      FieldName = 'dat_lancamento'
      Size = 255
    end
    object memTableLancamentosdes_tipo: TWideStringField
      FieldName = 'des_tipo'
      Size = 255
    end
    object memTableLancamentosval_lancamento: TWideStringField
      FieldName = 'val_lancamento'
      Size = 255
    end
  end
  object memTableEntregasDia: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 72
    object memTableEntregasDiacod_cliente: TStringField
      FieldName = 'cod_cliente'
      Size = 5
    end
    object memTableEntregasDiadat_baixa: TStringField
      FieldName = 'dat_baixa'
      Size = 10
    end
    object memTableEntregasDiaqtd_entregas: TStringField
      FieldName = 'qtd_entregas'
      Size = 6
    end
    object memTableEntregasDiades_tipo: TStringField
      FieldName = 'des_tipo'
    end
  end
  object memTableEntregasDetalhe: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 128
    object memTableEntregasDetalhenum_remessa: TStringField
      FieldName = 'num_remessa'
    end
    object memTableEntregasDetalheqtd_peso: TStringField
      FieldName = 'qtd_peso'
      Size = 15
    end
    object memTableEntregasDetalhedes_tipo: TStringField
      FieldName = 'des_tipo'
      Size = 30
    end
  end
  object memTableTracking: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 272
    Top = 184
    object memTableTrackingid_tracking: TIntegerField
      FieldName = 'id_tracking'
    end
    object memTableTrackingdat_tracking: TDateTimeField
      FieldName = 'dat_tracking'
    end
    object memTableTrackingnum_remessa: TStringField
      FieldName = 'num_remessa'
    end
    object memTableTrackingcod_awb: TStringField
      FieldName = 'cod_awb'
    end
    object memTableTrackingdes_logradouro: TStringField
      FieldName = 'des_logradouro'
      Size = 70
    end
    object memTableTrackingnum_logradouro: TStringField
      FieldName = 'num_logradouro'
      Size = 11
    end
    object memTableTrackingnom_bairro: TStringField
      FieldName = 'nom_bairro'
      Size = 70
    end
    object memTableTrackingnom_cidade_uf: TStringField
      FieldName = 'nom_cidade_uf'
      Size = 75
    end
    object memTableTrackingnum_cep: TStringField
      FieldName = 'num_cep'
      Size = 9
    end
    object memTableTrackingnum_telefone_1: TStringField
      FieldName = 'num_telefone_1'
    end
    object memTableTrackingnum_telefone_2: TStringField
      FieldName = 'num_telefone_2'
    end
    object memTableTrackingnum_telefone_3: TStringField
      FieldName = 'num_telefone_3'
    end
    object memTableTrackingdes_complemento: TStringField
      FieldName = 'des_complemento'
      Size = 256
    end
  end
end

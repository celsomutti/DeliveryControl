unit DM.Main;

interface

uses
  System.SysUtils, System.Classes, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, System.ImageList, FMX.ImgList;

type
  TDM_Main = class(TDataModule)
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    RESTResponseDataSetAdapter: TRESTResponseDataSetAdapter;
    memTableExtrato: TFDMemTable;
    memTableExtratoid_extrato: TWideStringField;
    memTableExtratodat_inicio: TWideStringField;
    memTableExtratodat_final: TWideStringField;
    memTableExtratonum_ano: TWideStringField;
    memTableExtratonum_mes: TWideStringField;
    memTableExtratonum_quinzena: TWideStringField;
    memTableExtratocod_base: TWideStringField;
    memTableExtratocod_entregador: TWideStringField;
    memTableExtratonum_extrato: TWideStringField;
    memTableExtratoval_verba: TWideStringField;
    memTableExtratoqtd_volumes: TWideStringField;
    memTableExtratoqtd_volumes_extra: TWideStringField;
    memTableExtratoval_volumes_extra: TWideStringField;
    memTableExtratoqtd_entregas: TWideStringField;
    memTableExtratoqtd_atraso: TWideStringField;
    memTableExtratoval_performance: TWideStringField;
    memTableExtratoval_producao: TWideStringField;
    memTableExtratoval_creditos: TWideStringField;
    memTableExtratoval_debitos: TWideStringField;
    memTableExtratoval_extravios: TWideStringField;
    memTableExtratoval_total_expressa: TWideStringField;
    memTableExtratoval_total_empresa: TWideStringField;
    memTableExtratocod_cliente: TWideStringField;
    memTableExtratodat_credito: TWideStringField;
    memTableExtratodes_unique_key: TWideStringField;
    memTableDatasCreditos: TFDMemTable;
    memTableDatasCreditosdat_credito: TWideStringField;
    memTableBoletos: TFDMemTable;
    memTableBoletosid_boleto: TWideStringField;
    memTableBoletosnum_extrato: TWideStringField;
    memTableBoletosdat_credito: TWideStringField;
    memTableBoletosnum_linha_boleto: TWideStringField;
    memTableBoletosval_boleto: TWideStringField;
    memTableBoletoscod_expressa: TWideStringField;
    memTableBoletosdat_cadastro: TWideStringField;
    memTableBoletosnom_usuario: TWideStringField;
    memTableBoletosdom_recebido: TWideStringField;
    memTableEntregas: TFDMemTable;
    memTableEntregascod_entregador: TWideStringField;
    memTableEntregasval_verba: TWideStringField;
    memTableEntregasqtd_entregas: TWideStringField;
    memTableEntregasnum_extrato: TWideStringField;
    memTableExtravios: TFDMemTable;
    memTableExtraviosdes_extravio: TWideStringField;
    memTableExtraviosnum_nossonumero: TWideStringField;
    memTableExtravioscod_entregador: TWideStringField;
    memTableExtraviosval_total: TWideStringField;
    memTableLancamentos: TFDMemTable;
    memTableLancamentosdes_lancamento: TWideStringField;
    memTableLancamentosdat_lancamento: TWideStringField;
    memTableLancamentosdes_tipo: TWideStringField;
    memTableLancamentosval_lancamento: TWideStringField;
    memTableEntregascod_cliente: TStringField;
    memTableEntregasdes_tipo: TStringField;
    memTableEntregasDia: TFDMemTable;
    memTableEntregasDiacod_cliente: TStringField;
    memTableEntregasDiadat_baixa: TStringField;
    memTableEntregasDiaqtd_entregas: TStringField;
    memTableEntregasDiades_tipo: TStringField;
    memTableEntregasDetalhe: TFDMemTable;
    memTableEntregasDetalhenum_remessa: TStringField;
    memTableEntregasDetalheqtd_peso: TStringField;
    memTableEntregasDetalhedes_tipo: TStringField;
    memTableTracking: TFDMemTable;
    memTableTrackingid_tracking: TIntegerField;
    memTableTrackingdat_tracking: TDateTimeField;
    memTableTrackingnum_remessa: TStringField;
    memTableTrackingcod_awb: TStringField;
    memTableTrackingdes_logradouro: TStringField;
    memTableTrackingnum_logradouro: TStringField;
    memTableTrackingnom_bairro: TStringField;
    memTableTrackingnom_cidade_uf: TStringField;
    memTableTrackingnum_cep: TStringField;
    memTableTrackingnum_telefone_1: TStringField;
    memTableTrackingnum_telefone_2: TStringField;
    memTableTrackingnum_telefone_3: TStringField;
    memTableTrackingdes_complemento: TStringField;
    imageList16_16: TImageList;
    memTableEntregasDiaval_verba: TStringField;
    memTableEntregasDianom_cliente: TStringField;
    memTableExtratonom_cliente: TStringField;
    memTableEntregasnom_cliente: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM_Main: TDM_Main;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.

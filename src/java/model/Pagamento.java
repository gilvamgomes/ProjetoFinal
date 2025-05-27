package model;

import java.util.Date;

public class Pagamento {
    private int idPagamento;
    private String tipoPagamento;
    private double valor;
    private Date dataPagamento;
    private int funcionario_idFfuncionario;

    public int getIdPagamento() {
        return idPagamento;
    }

    public void setIdPagamento(int idPagamento) {
        this.idPagamento = idPagamento;
    }

    public String getTipoPagamento() {
        return tipoPagamento;
    }

    public void setTipoPagamento(String tipoPagamento) {
        this.tipoPagamento = tipoPagamento;
    }

    public double getValor() {
        return valor;
    }

    public void setValor(double valor) {
        this.valor = valor;
    }

    public Date getDataPagamento() {
        return dataPagamento;
    }

    public void setDataPagamento(Date dataPagamento) {
        this.dataPagamento = dataPagamento;
    }

    public int getFuncionario_idFfuncionario() {
        return funcionario_idFfuncionario;
    }

    public void setFuncionario_idFfuncionario(int funcionario_idFfuncionario) {
        this.funcionario_idFfuncionario = funcionario_idFfuncionario;
    }
}

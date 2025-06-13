package model;

import java.math.BigDecimal;

public class ContraCheque {

    private int idContraCheque;
    private BigDecimal valorBruto;
    private BigDecimal descontos;
    private BigDecimal valorLiquido;
    private int funcionarioId;
    private int mes;
    private int ano;
    private String nomeFuncionario; // Novo campo

    public ContraCheque() {
    }

    public ContraCheque(int idContraCheque, BigDecimal valorBruto, BigDecimal descontos, BigDecimal valorLiquido, int funcionarioId) {
        this.idContraCheque = idContraCheque;
        this.valorBruto = valorBruto;
        this.descontos = descontos;
        this.valorLiquido = valorLiquido;
        this.funcionarioId = funcionarioId;
    }

    public int getIdContraCheque() {
        return idContraCheque;
    }

    public void setIdContraCheque(int idContraCheque) {
        this.idContraCheque = idContraCheque;
    }

    public BigDecimal getValorBruto() {
        return valorBruto;
    }

    public void setValorBruto(BigDecimal valorBruto) {
        this.valorBruto = valorBruto;
    }

    public BigDecimal getDescontos() {
        return descontos;
    }

    public void setDescontos(BigDecimal descontos) {
        this.descontos = descontos;
    }

    public BigDecimal getValorLiquido() {
        return valorLiquido;
    }

    public void setValorLiquido(BigDecimal valorLiquido) {
        this.valorLiquido = valorLiquido;
    }

    public int getFuncionarioId() {
        return funcionarioId;
    }

    public void setFuncionarioId(int funcionarioId) {
        this.funcionarioId = funcionarioId;
    }

    public int getMes() {
        return mes;
    }

    public void setMes(int mes) {
        this.mes = mes;
    }

    public int getAno() {
        return ano;
    }

    public void setAno(int ano) {
        this.ano = ano;
    }

    public String getNomeFuncionario() {
        return nomeFuncionario;
    }

    public void setNomeFuncionario(String nomeFuncionario) {
        this.nomeFuncionario = nomeFuncionario;
    }
}

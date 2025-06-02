package model;

import java.math.BigDecimal;

public class Imposto {
    private int idImposto;
    private String descricao;
    private String tipo;
    private BigDecimal faixaInicio;
    private BigDecimal faixaFim;
    private BigDecimal aliquota;
    private BigDecimal parcelaDeduzir;

    public int getIdImposto() {
        return idImposto;
    }

    public void setIdImposto(int idImposto) {
        this.idImposto = idImposto;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public BigDecimal getFaixaInicio() {
        return faixaInicio;
    }

    public void setFaixaInicio(BigDecimal faixaInicio) {
        this.faixaInicio = faixaInicio;
    }

    public BigDecimal getFaixaFim() {
        return faixaFim;
    }

    public void setFaixaFim(BigDecimal faixaFim) {
        this.faixaFim = faixaFim;
    }

    public BigDecimal getAliquota() {
        return aliquota;
    }

    public void setAliquota(BigDecimal aliquota) {
        this.aliquota = aliquota;
    }

    public BigDecimal getParcelaDeduzir() {
        return parcelaDeduzir;
    }

    public void setParcelaDeduzir(BigDecimal parcelaDeduzir) {
        this.parcelaDeduzir = parcelaDeduzir;
    }
}

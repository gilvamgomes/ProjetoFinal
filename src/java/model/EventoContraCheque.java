package model;

import java.math.BigDecimal;

public class EventoContraCheque {
    private String descricao;
    private BigDecimal valor;
    private boolean ehDesconto;

    public EventoContraCheque() {}

    public EventoContraCheque(String descricao, BigDecimal valor, boolean ehDesconto) {
        this.descricao = descricao;
        this.valor = valor;
        this.ehDesconto = ehDesconto;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public BigDecimal getValor() {
        return valor;
    }

    public void setValor(BigDecimal valor) {
        this.valor = valor;
    }

    public boolean isEhDesconto() {
        return ehDesconto;
    }

    public void setEhDesconto(boolean ehDesconto) {
        this.ehDesconto = ehDesconto;
    }
}

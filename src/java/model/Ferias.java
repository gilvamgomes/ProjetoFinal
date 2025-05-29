package model;

import java.util.Date;

public class Ferias {
    private int idFerias;
    private Date dataInicio;
    private Date dataFim;
    private String status;
    private int funcionario_idFfuncionario;

    public int getIdFerias() {
        return idFerias;
    }

    public void setIdFerias(int idFerias) {
        this.idFerias = idFerias;
    }

    public Date getDataInicio() {
        return dataInicio;
    }

    public void setDataInicio(Date dataInicio) {
        this.dataInicio = dataInicio;
    }

    public Date getDataFim() {
        return dataFim;
    }

    public void setDataFim(Date dataFim) {
        this.dataFim = dataFim;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getFuncionario_idFfuncionario() {
        return funcionario_idFfuncionario;
    }

    public void setFuncionario_idFfuncionario(int funcionario_idFfuncionario) {
        this.funcionario_idFfuncionario = funcionario_idFfuncionario;
    }
}

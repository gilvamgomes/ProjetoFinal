package model;

import java.sql.Date;
import java.sql.Time;

public class RegistroPonto {
    private int idRegistro_ponto;
    private Date data;
    private Time horaEntrada;
    private Time horaSaida;
    private int funcionario_idFfuncionario;

    // Novo atributo para relacionamento com Funcionario
    private Funcionario funcionario;

    // Getters e Setters

    public int getIdRegistro_ponto() {
        return idRegistro_ponto;
    }

    public void setIdRegistro_ponto(int idRegistro_ponto) {
        this.idRegistro_ponto = idRegistro_ponto;
    }

    public Date getData() {
        return data;
    }

    public void setData(Date data) {
        this.data = data;
    }

    public Time getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(Time horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public Time getHoraSaida() {
        return horaSaida;
    }

    public void setHoraSaida(Time horaSaida) {
        this.horaSaida = horaSaida;
    }

    public int getFuncionario_idFfuncionario() {
        return funcionario_idFfuncionario;
    }

    public void setFuncionario_idFfuncionario(int funcionario_idFfuncionario) {
        this.funcionario_idFfuncionario = funcionario_idFfuncionario;
    }

    // Getters e setters do objeto Funcionario

    public Funcionario getFuncionario() {
        return funcionario;
    }

    public void setFuncionario(Funcionario funcionario) {
        this.funcionario = funcionario;
    }
}

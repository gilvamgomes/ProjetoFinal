package model;

import java.time.LocalDate;
import java.time.LocalTime;

public class RegistroPonto {
    private int idRegistro_ponto;
    private LocalDate data;
    private LocalTime horaEntrada;
    private LocalTime horaSaidaAlmoco;
    private LocalTime horaVoltaAlmoco;
    private LocalTime horaSaidaFinal;
    private double horasTrabalhadas;
    private int funcionario_idFfuncionario;

    private Funcionario funcionario;

    public int getIdRegistro_ponto() {
        return idRegistro_ponto;
    }

    public void setIdRegistro_ponto(int idRegistro_ponto) {
        this.idRegistro_ponto = idRegistro_ponto;
    }

    public LocalDate getData() {
        return data;
    }

    public void setData(LocalDate data) {
        this.data = data;
    }

    public LocalTime getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(LocalTime horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public LocalTime getHoraSaidaAlmoco() {
        return horaSaidaAlmoco;
    }

    public void setHoraSaidaAlmoco(LocalTime horaSaidaAlmoco) {
        this.horaSaidaAlmoco = horaSaidaAlmoco;
    }

    public LocalTime getHoraVoltaAlmoco() {
        return horaVoltaAlmoco;
    }

    public void setHoraVoltaAlmoco(LocalTime horaVoltaAlmoco) {
        this.horaVoltaAlmoco = horaVoltaAlmoco;
    }

    public LocalTime getHoraSaidaFinal() {
        return horaSaidaFinal;
    }

    public void setHoraSaidaFinal(LocalTime horaSaidaFinal) {
        this.horaSaidaFinal = horaSaidaFinal;
    }

    public double getHorasTrabalhadas() {
        return horasTrabalhadas;
    }

    public void setHorasTrabalhadas(double horasTrabalhadas) {
        this.horasTrabalhadas = horasTrabalhadas;
    }

    public int getFuncionario_idFfuncionario() {
        return funcionario_idFfuncionario;
    }

    public void setFuncionario_idFfuncionario(int funcionario_idFfuncionario) {
        this.funcionario_idFfuncionario = funcionario_idFfuncionario;
    }

    public Funcionario getFuncionario() {
        return funcionario;
    }

    public void setFuncionario(Funcionario funcionario) {
        this.funcionario = funcionario;
    }
}

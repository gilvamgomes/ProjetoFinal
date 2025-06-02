package model;

import java.time.LocalDate;
import java.time.LocalTime;

public class RegistroPonto {
    private int idRegistro_ponto;
    private LocalDate data;
    private LocalTime horaEntrada;
    private LocalTime horaAlmocoSaida;
    private LocalTime horaAlmocoVolta;
    private LocalTime horaSaida;
    private double horasTrabalhadas;
    private int funcionario_idFfuncionario;
    private Funcionario funcionario;

    // Getters e setters
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

    public LocalTime getHoraAlmocoSaida() {
        return horaAlmocoSaida;
    }

    public void setHoraAlmocoSaida(LocalTime horaAlmocoSaida) {
        this.horaAlmocoSaida = horaAlmocoSaida;
    }

    public LocalTime getHoraAlmocoVolta() {
        return horaAlmocoVolta;
    }

    public void setHoraAlmocoVolta(LocalTime horaAlmocoVolta) {
        this.horaAlmocoVolta = horaAlmocoVolta;
    }

    public LocalTime getHoraSaida() {
        return horaSaida;
    }

    public void setHoraSaida(LocalTime horaSaida) {
        this.horaSaida = horaSaida;
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

    // ✅ Para usar no JSP com fmt:formatDate
    public java.util.Date getDataFormatada() {
        return java.sql.Date.valueOf(this.data);
    }

    // ✅ Para exibir horas no formato "Xh Ymin"
    public String getHorasTrabalhadasFormatada() {
        int horas = (int) this.horasTrabalhadas;
        int minutos = (int) Math.round((this.horasTrabalhadas - horas) * 60);
        return horas + "h " + minutos + "min";
    }
}

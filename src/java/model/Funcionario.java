package model;

import java.util.Date;

public class Funcionario {

    private int idFuncionario;
    private String nome;
    private Date dataNasc;
    private String cpf;
    private String cargo;
    private int status;
    private Usuario usuario;  // Relacionamento com Usuario

    public Funcionario(int idFuncionario, String nome, Date dataNasc, String cpf, String cargo, int status, Usuario usuario) {
        this.idFuncionario = idFuncionario;
        this.nome = nome;
        this.dataNasc = dataNasc;
        this.cpf = cpf;
        this.cargo = cargo;
        this.status = status;
        this.usuario = usuario;
    }

    public Funcionario() {
    }

    public int getIdFuncionario() {
        return idFuncionario;
    }

    public void setIdFuncionario(int idFuncionario) {
        this.idFuncionario = idFuncionario;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public Date getDataNasc() {
        return dataNasc;
    }

    public void setDataNasc(Date dataNasc) {
        this.dataNasc = dataNasc;
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    @Override
    public String toString() {
        return "Funcionario{" + "nome=" + nome + '}';
    }
}
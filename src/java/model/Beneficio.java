package model;

public class Beneficio {

    private int idBeneficio;
    private String nome;
    private String descricao;
    private int status;

    // Campos auxiliares para uso em tela (não vêm do banco diretamente)
    private double valorTemporario; // valor específico para o funcionário
    private boolean ativoParaFuncionario; // para marcar checkbox

    public Beneficio() {
    }

    public Beneficio(int idBeneficio, String nome, String descricao, int status) {
        this.idBeneficio = idBeneficio;
        this.nome = nome;
        this.descricao = descricao;
        this.status = status;
    }

    public int getIdBeneficio() {
        return idBeneficio;
    }

    public void setIdBeneficio(int idBeneficio) {
        this.idBeneficio = idBeneficio;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    // Getters e setters novos:

    public double getValorTemporario() {
        return valorTemporario;
    }

    public void setValorTemporario(double valorTemporario) {
        this.valorTemporario = valorTemporario;
    }

    public boolean isAtivoParaFuncionario() {
        return ativoParaFuncionario;
    }

    public void setAtivoParaFuncionario(boolean ativoParaFuncionario) {
        this.ativoParaFuncionario = ativoParaFuncionario;
    }
}

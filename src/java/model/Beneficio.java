package model;

public class Beneficio {

    private int idBeneficio;
    private String nome;
    private String descricao;
    private int status;

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
}
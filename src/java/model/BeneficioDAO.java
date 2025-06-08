package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BeneficioDAO extends DataBaseDAO {

    public BeneficioDAO() throws Exception {
    }

    public List<Beneficio> listar() throws SQLException {
        List<Beneficio> lista = new ArrayList<>();
        String SQL = "SELECT * FROM beneficio WHERE status = 1";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                Beneficio b = new Beneficio();
                b.setIdBeneficio(rs.getInt("idBeneficio"));
                b.setNome(rs.getString("nome"));
                b.setDescricao(rs.getString("descricao"));
                b.setStatus(rs.getInt("status"));
                lista.add(b);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar benefícios: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    // ✅ Para JSTL: ${bDAO.lista} → traz só ativos
    public List<Beneficio> getLista() throws Exception {
        return listar();
    }

    // ✅ NOVO: Traz todos os benefícios (sem filtro de status)
    public List<Beneficio> getTodos() throws Exception {
        List<Beneficio> lista = new ArrayList<>();
        String SQL = "SELECT * FROM beneficio";

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(SQL);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                Beneficio b = new Beneficio();
                b.setIdBeneficio(rs.getInt("idBeneficio"));
                b.setNome(rs.getString("nome"));
                b.setDescricao(rs.getString("descricao"));
                b.setStatus(rs.getInt("status"));
                lista.add(b);
            }

        } finally {
            this.desconectar();
        }

        return lista;
    }

    public boolean gravar(Beneficio b) {
        try {
            this.conectar();
            String sql;
            if (b.getIdBeneficio() == 0) {
                sql = "INSERT INTO beneficio (nome, descricao, status) VALUES (?, ?, ?)";
            } else {
                sql = "UPDATE beneficio SET nome=?, descricao=?, status=? WHERE idBeneficio=?";
            }

            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setString(1, b.getNome());
            pstm.setString(2, b.getDescricao());
            pstm.setInt(3, b.getStatus());

            if (b.getIdBeneficio() > 0) {
                pstm.setInt(4, b.getIdBeneficio());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar: " + e);
            return false;
        }
    }

    public Beneficio getCarregaPorID(int idBeneficio) throws Exception {
        Beneficio b = new Beneficio();
        String sql = "SELECT * FROM beneficio WHERE idBeneficio=?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idBeneficio);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            b.setIdBeneficio(rs.getInt("idBeneficio"));
            b.setNome(rs.getString("nome"));
            b.setDescricao(rs.getString("descricao"));
            b.setStatus(rs.getInt("status"));
        }

        this.desconectar();
        return b;
    }

    public boolean excluir(Beneficio b) {
        try {
            this.conectar();
            String sql = "UPDATE beneficio SET status=2 WHERE idBeneficio=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, b.getIdBeneficio());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao excluir: " + e);
            return false;
        }
    }
    
    
    //Barra de busca
    public List<Beneficio> buscarPorTermo(String termo) throws Exception {
    List<Beneficio> lista = new ArrayList<>();

    // Mapeia palavras como "ativo" e "inativo" pra status 1 e 2
    Integer status = null;
    if (termo.equalsIgnoreCase("ativo")) {
        status = 1;
    } else if (termo.equalsIgnoreCase("inativo")) {
        status = 2;
    }

    String sql = "SELECT * FROM beneficio WHERE " +
                 "nome LIKE ? OR descricao LIKE ? OR idBeneficio LIKE ?" +
                 (status != null ? " OR status = ?" : "");

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String buscaLike = "%" + termo + "%";
        pstm.setString(1, buscaLike); // nome
        pstm.setString(2, buscaLike); // descricao
        pstm.setString(3, buscaLike); // id

        if (status != null) {
            pstm.setInt(4, status);
        }

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Beneficio b = new Beneficio();
            b.setIdBeneficio(rs.getInt("idBeneficio"));
            b.setNome(rs.getString("nome"));
            b.setDescricao(rs.getString("descricao"));
            b.setStatus(rs.getInt("status"));
            lista.add(b);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

}

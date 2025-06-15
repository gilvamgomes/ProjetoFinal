package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeriasDAO extends DataBaseDAO {

    public FeriasDAO() throws Exception {}

    public List<Ferias> getLista() throws SQLException {
        List<Ferias> lista = new ArrayList<>();
        String SQL = "SELECT * FROM ferias";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                Ferias f = new Ferias();
                f.setIdFerias(rs.getInt("idFerias"));
                f.setDataInicio(rs.getDate("dataInicio"));
                f.setDataFim(rs.getDate("dataFim"));
                f.setStatus(rs.getString("status"));
                f.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));

                try {
                    FuncionarioDAO funcDAO = new FuncionarioDAO();
                    Funcionario func = funcDAO.getCarregaPorID(f.getFuncionario_idFfuncionario());
                    f.setFuncionario(func);
                } catch (Exception e) {
                    System.out.println("Erro ao carregar funcionário na lista geral: " + e.getMessage());
                }

                lista.add(f);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar férias: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public List<Ferias> getListaPorFuncionario(int idFuncionario) throws SQLException {
        List<Ferias> lista = new ArrayList<>();
        String SQL = "SELECT * FROM ferias WHERE funcionario_idFfuncionario=?";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            pstm.setInt(1, idFuncionario);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                Ferias f = new Ferias();
                f.setIdFerias(rs.getInt("idFerias"));
                f.setDataInicio(rs.getDate("dataInicio"));
                f.setDataFim(rs.getDate("dataFim"));
                f.setStatus(rs.getString("status"));
                f.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));

                try {
                    FuncionarioDAO funcDAO = new FuncionarioDAO();
                    Funcionario func = funcDAO.getCarregaPorID(f.getFuncionario_idFfuncionario());
                    f.setFuncionario(func);
                } catch (Exception e) {
                    System.out.println("Erro ao carregar funcionário na lista por funcionário: " + e.getMessage());
                }

                lista.add(f);
            }
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(Ferias f) {
        try {
            this.conectar();
            String sql;
            if (f.getIdFerias() == 0) {
                sql = "INSERT INTO ferias (dataInicio, dataFim, status, funcionario_idFfuncionario) VALUES (?, ?, ?, ?)";
            } else {
                sql = "UPDATE ferias SET dataInicio=?, dataFim=?, status=?, funcionario_idFfuncionario=? WHERE idFerias=?";
            }

            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setDate(1, new java.sql.Date(f.getDataInicio().getTime()));
            pstm.setDate(2, new java.sql.Date(f.getDataFim().getTime()));
            pstm.setString(3, f.getStatus());
            pstm.setInt(4, f.getFuncionario_idFfuncionario());

            if (f.getIdFerias() > 0) {
                pstm.setInt(5, f.getIdFerias());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar férias: " + e);
            return false;
        }
    }

    public Ferias getCarregaPorID(int idFerias) throws Exception {
        Ferias f = new Ferias();
        String sql = "SELECT * FROM ferias WHERE idFerias=?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idFerias);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            f.setIdFerias(rs.getInt("idFerias"));
            f.setDataInicio(rs.getDate("dataInicio"));
            f.setDataFim(rs.getDate("dataFim"));
            f.setStatus(rs.getString("status"));
            f.setFuncionario_idFfuncionario(rs.getInt("funcionario_idFfuncionario"));

            try {
                FuncionarioDAO funcDAO = new FuncionarioDAO();
                Funcionario func = funcDAO.getCarregaPorID(f.getFuncionario_idFfuncionario());
                f.setFuncionario(func);
            } catch (Exception e) {
                System.out.println("Erro ao carregar funcionário na busca por ID: " + e.getMessage());
            }
        }

        this.desconectar();
        return f;
    }

    public boolean excluir(Ferias f) {
        try {
            this.conectar();
            String sql = "DELETE FROM ferias WHERE idFerias=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, f.getIdFerias());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao excluir férias: " + e);
            return false;
        }
    }
    
     //Barra de busca
    public List<Ferias> buscarPorTermo(String termo) throws Exception {
    List<Ferias> lista = new ArrayList<>();

    String sql = "SELECT f.*, u.nome as nomeFuncionario FROM ferias f " +
                 "JOIN funcionario u ON f.funcionario_idFfuncionario = u.idFfuncionario " +
                 "WHERE CAST(f.idFerias AS CHAR) LIKE ? " +
                 "OR DATE_FORMAT(f.dataInicio, '%d/%m/%Y') LIKE ? " +
                 "OR DATE_FORMAT(f.dataFim, '%d/%m/%Y') LIKE ? " +
                 "OR CAST(f.status AS CHAR) LIKE ? " +
                 "OR u.nome LIKE ?";

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String filtro = "%" + termo + "%";
        for (int i = 1; i <= 5; i++) {
            pstm.setString(i, filtro);
        }

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Ferias f = new Ferias();
            f.setIdFerias(rs.getInt("idFerias"));
            f.setDataInicio(rs.getDate("dataInicio"));
            f.setDataFim(rs.getDate("dataFim"));
            f.setStatus(rs.getString("status"));

            Funcionario func = new Funcionario();
            func.setIdFuncionario(rs.getInt("funcionario_idFfuncionario"));
            func.setNome(rs.getString("nomeFuncionario"));
            f.setFuncionario(func);

            lista.add(f);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}
}

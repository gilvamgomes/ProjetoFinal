package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class FuncionarioDAO extends DataBaseDAO {

    public FuncionarioDAO() throws Exception {}

    // Método listar que chama getLista para facilitar uso externo
    public List<Funcionario> listar() throws Exception {
        return getLista();
    }

    public List<Funcionario> getLista() throws SQLException, ClassNotFoundException, Exception {
        List<Funcionario> lista = new ArrayList<>();
        String SQL = "SELECT * FROM funcionario";

        UsuarioDAO uDAO = new UsuarioDAO();

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(SQL);
             ResultSet rs = pstm.executeQuery()) {

            while (rs.next()) {
                Funcionario f = new Funcionario();
                f.setIdFuncionario(rs.getInt("idFfuncionario"));
                f.setNome(rs.getString("nome"));
                f.setDataNasc(rs.getDate("dataNasc"));
                f.setCpf(rs.getString("cpf"));
                f.setCargo(rs.getString("cargo"));
                f.setStatus(rs.getInt("status"));

                f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));

                lista.add(f);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar funcionários: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(Funcionario f) {
        try {
            this.conectar();
            String sql;
            if (f.getIdFuncionario() == 0) {
                sql = "INSERT INTO funcionario (nome, dataNasc, cpf, cargo, status, usuario_idUsuario) VALUES (?, ?, ?, ?, ?, ?)";
            } else {
                sql = "UPDATE funcionario SET nome=?, dataNasc=?, cpf=?, cargo=?, status=?, usuario_idUsuario=? WHERE idFfuncionario=?";
            }

            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setString(1, f.getNome());
                pstm.setDate(2, new Date(f.getDataNasc().getTime()));
                pstm.setString(3, f.getCpf());
                pstm.setString(4, f.getCargo());
                pstm.setInt(5, f.getStatus());
                pstm.setInt(6, f.getUsuario().getIdUsuario());

                if (f.getIdFuncionario() > 0) {
                    pstm.setInt(7, f.getIdFuncionario());
                }

                pstm.execute();
            }

            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar funcionário: " + e);
            return false;
        }
    }

    public Funcionario getCarregaPorID(int idFuncionario) throws Exception {
        Funcionario f = new Funcionario();
        String sql = "SELECT * FROM funcionario WHERE idFfuncionario=?";

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            pstm.setInt(1, idFuncionario);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    f.setIdFuncionario(rs.getInt("idFfuncionario"));
                    f.setNome(rs.getString("nome"));
                    f.setDataNasc(rs.getDate("dataNasc"));
                    f.setCpf(rs.getString("cpf"));
                    f.setCargo(rs.getString("cargo"));
                    f.setStatus(rs.getInt("status"));

                    UsuarioDAO uDAO = new UsuarioDAO();
                    f.setUsuario(uDAO.getCarregaPorID(rs.getInt("usuario_idUsuario")));
                }
            }
        } finally {
            this.desconectar();
        }
        return f;
    }

    public boolean excluir(Funcionario f) {
        try {
            this.conectar();
            String sql = "UPDATE funcionario SET status=2 WHERE idFfuncionario=?";
            try (PreparedStatement pstm = conn.prepareStatement(sql)) {
                pstm.setInt(1, f.getIdFuncionario());
                pstm.execute();
            }
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao excluir funcionário: " + e);
            return false;
        }
    }

    // ✅ Método novo: pega o Funcionario pelo ID do usuário
    public Funcionario getFuncionarioPorUsuario(int idUsuario) throws Exception {
        Funcionario f = null;
        String sql = "SELECT * FROM funcionario WHERE usuario_idUsuario = ?";

        this.conectar();
        try (PreparedStatement pstm = this.conn.prepareStatement(sql)) {
            pstm.setInt(1, idUsuario);
            try (ResultSet rs = pstm.executeQuery()) {
                if (rs.next()) {
                    f = new Funcionario();
                    f.setIdFuncionario(rs.getInt("idFfuncionario"));
                    f.setNome(rs.getString("nome"));
                    // Se quiser pode setar outros campos também
                }
            }
        } finally {
            this.desconectar();
        }
        return f;
    }
}

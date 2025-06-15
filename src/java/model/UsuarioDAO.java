package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO extends DataBaseDAO {

    public UsuarioDAO() throws Exception {}

    public List<Usuario> getLista() throws SQLException, ClassNotFoundException, Exception {
        List<Usuario> lista = new ArrayList<>();
        String SQL = "SELECT * FROM usuario";

        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                Usuario u = new Usuario();
                u.setIdUsuario(rs.getInt("idUsuario"));
                u.setNome(rs.getString("nome"));
                u.setLogin(rs.getString("login"));
                u.setSenha(rs.getString("senha"));
                u.setStatus(rs.getInt("status"));

                PerfilDAO pDAO = new PerfilDAO();
                u.setPerfil(pDAO.getCarregaPorID(rs.getInt("idPerfil")));

                lista.add(u);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar usuários: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(Usuario u) {
        try {
            this.conectar();
            String sql;
            PreparedStatement pstm;

            if (u.getIdUsuario() == 0) {
                sql = "INSERT INTO usuario (nome, login, senha, status, idPerfil) VALUES (?, ?, ?, ?, ?)";
                pstm = conn.prepareStatement(sql);

                pstm.setString(1, u.getNome());
                pstm.setString(2, u.getLogin());
                pstm.setString(3, u.getSenha());
                pstm.setInt(4, u.getStatus());
                pstm.setInt(5, u.getPerfil().getIdPerfil());

            } else {
                sql = "UPDATE usuario SET nome=?, login=?, senha=?, status=?, idPerfil=? WHERE idUsuario=?";
                pstm = conn.prepareStatement(sql);

                pstm.setString(1, u.getNome());
                pstm.setString(2, u.getLogin());
                pstm.setString(3, u.getSenha());
                pstm.setInt(4, u.getStatus());
                pstm.setInt(5, u.getPerfil().getIdPerfil());
                pstm.setInt(6, u.getIdUsuario());
            }

            pstm.execute();
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar: " + e);
            return false;
        }
    }

    public Usuario getCarregaPorID(int idUsuario) throws Exception {
        Usuario u = new Usuario();
        String sql = "SELECT u.*, p.nome FROM usuario u INNER JOIN perfil p ON p.idPerfil = u.idPerfil WHERE u.idUsuario=?";

        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idUsuario);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            u.setIdUsuario(rs.getInt("u.idUsuario"));
            u.setNome(rs.getString("u.nome"));
            u.setLogin(rs.getString("u.login"));
            u.setSenha(rs.getString("u.senha"));
            u.setStatus(rs.getInt("u.status"));

            Perfil p = new Perfil();
            p.setIdPerfil(rs.getInt("u.idPerfil"));
            p.setNome(rs.getString("p.nome"));
            u.setPerfil(p);
        }

        this.desconectar();
        return u;
    }

    public boolean excluir(Usuario u) {
        try {
            this.conectar();
            String sql = "UPDATE usuario SET status=2 WHERE idUsuario=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, u.getIdUsuario());
            pstm.execute();
            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao excluir: " + e);
            return false;
        }
    }

    public Usuario getRecuperarUsuario(String login) {
        Usuario u = new Usuario();
        String sql = "SELECT * FROM usuario WHERE login=?";

        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setString(1, login);
            ResultSet rs = pstm.executeQuery();

            if (rs.next()) {
                u.setIdUsuario(rs.getInt("idUsuario"));
                u.setNome(rs.getString("nome"));
                u.setLogin(rs.getString("login"));
                u.setSenha(rs.getString("senha"));
                u.setStatus(rs.getInt("status"));

                PerfilDAO pDAO = new PerfilDAO();
                u.setPerfil(pDAO.getCarregaPorID(rs.getInt("idPerfil")));
            }

            this.desconectar();
            return u;

        } catch (Exception e) {
            System.out.println("Erro ao recuperar usuário: " + e);
            return null;
        }
    }
    //Barra de busca
    public List<Usuario> buscarPorTermo(String termo) throws Exception {
    List<Usuario> lista = new ArrayList<>();

    String sql = "SELECT u.*, p.nome AS perfil_nome FROM usuario u " +
                 "JOIN perfil p ON u.idPerfil = p.idPerfil " +
                 "WHERE LOWER(u.nome) LIKE ? " +
                 "OR CAST(u.idUsuario AS CHAR) LIKE ? " +
                 "OR LOWER(u.login) LIKE ? " +
                 "OR LOWER(p.nome) LIKE ? " +
                 "OR (u.status = 1 AND ? = 'ativo') " +
                 "OR (u.status = 0 AND ? = 'inativo')";

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String filtro = "%" + termo.toLowerCase() + "%";
        for (int i = 1; i <= 4; i++) {
            pstm.setString(i, filtro);
        }
        pstm.setString(5, termo.toLowerCase()); // ativo
        pstm.setString(6, termo.toLowerCase()); // inativo

        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Usuario u = new Usuario();
            u.setIdUsuario(rs.getInt("idUsuario"));
            u.setNome(rs.getString("nome"));
            u.setLogin(rs.getString("login"));
            u.setSenha(rs.getString("senha"));
            u.setStatus(rs.getInt("status"));

            Perfil p = new Perfil();
            p.setIdPerfil(rs.getInt("idPerfil"));
            p.setNome(rs.getString("perfil_nome"));
            u.setPerfil(p);

            lista.add(u);
        }
    } finally {
        this.desconectar();
    }

    return lista;
}

}

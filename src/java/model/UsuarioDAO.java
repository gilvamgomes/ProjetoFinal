package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Date;

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
                u.setDataNasc(rs.getDate("dataNasc"));
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
            if (u.getIdUsuario() == 0) {
                sql = "INSERT INTO usuario (nome, login, senha, dataNasc, status, idPerfil) VALUES (?, ?, ?, ?, ?, ?)";
            } else {
                sql = "UPDATE usuario SET nome=?, login=?, senha=?, dataNasc=?, status=?, idPerfil=? WHERE idUsuario=?";
            }

            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setString(1, u.getNome());
            pstm.setString(2, u.getLogin());
            pstm.setString(3, u.getSenha());
            pstm.setDate(4, new Date(u.getDataNasc().getTime()));
            pstm.setInt(5, u.getStatus());
            pstm.setInt(6, u.getPerfil().getIdPerfil());

            if (u.getIdUsuario() > 0) {
                pstm.setInt(7, u.getIdUsuario());
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
            u.setDataNasc(rs.getDate("u.dataNasc"));
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
                u.setDataNasc(rs.getDate("dataNasc"));
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
}
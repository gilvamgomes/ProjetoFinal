package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PerfilDAO extends DataBaseDAO {

    public PerfilDAO() throws ClassNotFoundException {
    }

    public List<Perfil> getLista() throws SQLException {
        List<Perfil> lista = new ArrayList<>();
        String SQL = "SELECT * FROM perfil";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Perfil p = new Perfil();
                p.setIdPerfil(rs.getInt("idPerfil"));
                p.setNome(rs.getString("nome"));
                p.setStatus(rs.getInt("status"));
                lista.add(p);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar perfis: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(Perfil p) {
        try {
            this.conectar();
            String sql;
            if (p.getIdPerfil() == 0)
                sql = "INSERT INTO perfil (nome, status) VALUES (?, ?)";
            else
                sql = "UPDATE perfil SET nome=?, status=? WHERE idPerfil=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setString(1, p.getNome());
            pstm.setInt(2, p.getStatus());
            if (p.getIdPerfil() > 0)
                pstm.setInt(3, p.getIdPerfil());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao gravar perfil: " + e);
            return false;
        }
    }

    public Perfil getCarregaPorID(int idPerfil) throws Exception {
        Perfil p = new Perfil();
        String sql = "SELECT * FROM perfil WHERE idPerfil=?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPerfil);
        ResultSet rs = pstm.executeQuery();
        if (rs.next()) {
            p.setIdPerfil(rs.getInt("idPerfil"));
            p.setNome(rs.getString("nome"));
            p.setStatus(rs.getInt("status"));
            p.setMenus(menusVinculadosPorPerfil(idPerfil));
            p.setNaoMenus(menusNaoVinculadosPorPerfil(idPerfil));
        }
        this.desconectar();
        return p;
    }

    public boolean excluir(Perfil p) {
        try {
            this.conectar();
            String sql = "UPDATE perfil SET status=2 WHERE idPerfil=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, p.getIdPerfil());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao excluir perfil: " + e);
            return false;
        }
    }

    public ArrayList<Menu> menusVinculadosPorPerfil(int idPerfil) throws Exception {
        ArrayList<Menu> lista = new ArrayList<>();
        String sql = "SELECT m.* FROM perfil_menu as mp, menu as m WHERE mp.menu_idMenu = m.idMenu AND mp.perfil_idPerfil = ?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPerfil);
        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Menu m = new Menu();
            m.setIdMenu(rs.getInt("idMenu"));
            m.setNome(rs.getString("nome"));
            m.setLink(rs.getString("link"));
            m.setIcone(rs.getString("icone"));
            m.setExibir(rs.getInt("exibir"));
            lista.add(m);
        }
        this.desconectar();
        return lista;
    }

    public ArrayList<Menu> menusNaoVinculadosPorPerfil(int idPerfil) throws Exception {
        ArrayList<Menu> lista = new ArrayList<>();
        String sql = "SELECT * FROM menu WHERE idMenu NOT IN (SELECT menu_idMenu FROM perfil_menu WHERE perfil_idPerfil = ?)";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idPerfil);
        ResultSet rs = pstm.executeQuery();
        while (rs.next()) {
            Menu m = new Menu();
            m.setIdMenu(rs.getInt("idMenu"));
            m.setNome(rs.getString("nome"));
            m.setLink(rs.getString("link"));
            m.setIcone(rs.getString("icone"));
            m.setExibir(rs.getInt("exibir"));
            lista.add(m);
        }
        this.desconectar();
        return lista;
    }

    public boolean vincular(int idPerfil, int idMenu) {
        try {
            String sql = "INSERT INTO perfil_menu (perfil_idPerfil, menu_idMenu) VALUES (?, ?)";
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, idPerfil);
            pstm.setInt(2, idMenu);
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao vincular menu: " + e);
            return false;
        }
    }

    public boolean desvincular(int idPerfil, int idMenu) {
        try {
            String sql = "DELETE FROM perfil_menu WHERE perfil_idPerfil=? AND menu_idMenu=?";
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, idPerfil);
            pstm.setInt(2, idMenu);
            pstm.execute();
            this.desconectar();
            return true;
        } catch (Exception e) {
            System.out.println("Erro ao desvincular menu: " + e);
            return false;
        }
    }
}
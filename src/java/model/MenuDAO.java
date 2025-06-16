package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO extends DataBaseDAO {

    public MenuDAO() throws ClassNotFoundException {
    }

    public List<Menu> getLista() throws SQLException {

        List<Menu> lista = new ArrayList<>();
        String SQL = "SELECT * FROM menu";
        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
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
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar menus: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    public boolean gravar(Menu m) {
        try {
            this.conectar();
            String sql;
            if (m.getIdMenu() == 0)
                sql = "INSERT INTO menu (nome, link, icone, exibir) VALUES (?, ?, ?, ?)";
            else
                sql = "UPDATE menu SET nome=?, link=?, icone=?, exibir=? WHERE idMenu=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setString(1, m.getNome());
            pstm.setString(2, m.getLink());
            pstm.setString(3, m.getIcone());
            pstm.setInt(4, m.getExibir());
            if (m.getIdMenu() > 0)
                pstm.setInt(5, m.getIdMenu());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao gravar menu: " + e);
            return false;
        }
    }

    public Menu getCarregaPorID(int idMenu) throws Exception {
        Menu m = new Menu();
        String sql = "SELECT * FROM menu WHERE idMenu=?";
        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idMenu);
        ResultSet rs = pstm.executeQuery();
        if (rs.next()) {
            m.setIdMenu(rs.getInt("idMenu"));
            m.setNome(rs.getString("nome"));
            m.setLink(rs.getString("link"));
            m.setIcone(rs.getString("icone"));
            m.setExibir(rs.getInt("exibir"));
        }
        this.desconectar();
        return m;
    }

    public boolean excluir(Menu m) {
        try {
            this.conectar();
            String sql = "DELETE FROM menu WHERE idMenu=?";
            PreparedStatement pstm = conn.prepareStatement(sql);
            pstm.setInt(1, m.getIdMenu());
            pstm.execute();
            this.desconectar();
            return true;
        } catch (SQLException e) {
            System.out.println("Erro ao excluir menu: " + e);
            return false;
        }
    }
<<<<<<< HEAD
    
    //Barra de busca
=======
     //Barra de busca
>>>>>>> Juntar_codigo
    public List<Menu> buscarPorTermo(String termo) throws Exception {
    List<Menu> lista = new ArrayList<>();
    String sql = "SELECT * FROM menu WHERE " +
                 "CAST(idMenu AS CHAR) LIKE ? OR " +
                 "nome LIKE ? OR " +
                 "link LIKE ? OR " +
                 "icone LIKE ? OR " +
                 "CAST(exibir AS CHAR) LIKE ?";

    this.conectar();
    try (PreparedStatement pstm = conn.prepareStatement(sql)) {
        String filtro = "%" + termo + "%";
        for (int i = 1; i <= 5; i++) {
            pstm.setString(i, filtro);
        }

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
    } finally {
        this.desconectar();
    }
    return lista;
}

<<<<<<< HEAD
=======
    // Barra de busca avançada (para perfil - só ID, Nome, Link)
    public List<Menu> buscarPorTermoAvancado(String termo) throws Exception {
        List<Menu> lista = new ArrayList<>();
        String sql = "SELECT * FROM menu WHERE " +
                     "CAST(idMenu AS CHAR) LIKE ? OR " +
                     "nome LIKE ? OR " +
                     "link LIKE ?";

        this.conectar();
        try (PreparedStatement pstm = conn.prepareStatement(sql)) {
            String filtro = "%" + termo + "%";
            pstm.setString(1, filtro);
            pstm.setString(2, filtro);
            pstm.setString(3, filtro);

            ResultSet rs = pstm.executeQuery();
            while (rs.next()) {
                Menu m = new Menu();
                m.setIdMenu(rs.getInt("idMenu"));
                m.setNome(rs.getString("nome"));
                m.setLink(rs.getString("link"));
                lista.add(m);
            }
        } finally {
            this.desconectar();
        }
        return lista;
    }
>>>>>>> Juntar_codigo
}
package model;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.Date;            // IMPORTAÇÃO CORRETA de java.sql.Date
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import utils.FeriadoUtils;
import utils.HorasUtils;

/**
 * DAO responsável por todas as operações de CRUD e geração de contra-cheque.
 */
public class ContraChequeDAO extends DataBaseDAO {

    public ContraChequeDAO() throws Exception {}

    /**
     * Retorna a lista completa de contra-cheques, já incluindo o nome do funcionário.
     */
    public List<ContraCheque> getLista() throws SQLException {
        List<ContraCheque> lista = new ArrayList<>();
        String SQL = "SELECT c.*, f.nome AS nomeFuncionario " +
                     "FROM contra_cheque c " +
                     "JOIN funcionario f ON f.idFfuncionario = c.funcionario_idFfuncionario";

        try {
            this.conectar();
            PreparedStatement pstm = conn.prepareStatement(SQL);
            ResultSet rs = pstm.executeQuery();

            while (rs.next()) {
                ContraCheque c = new ContraCheque();
                c.setIdContraCheque(rs.getInt("idContra_cheque"));
                c.setValorBruto(rs.getBigDecimal("valorBruto"));
                c.setDescontos(rs.getBigDecimal("descontos"));
                c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
                c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
                c.setMes(rs.getInt("mes"));
                c.setAno(rs.getInt("ano"));
                c.setNomeFuncionario(rs.getString("nomeFuncionario"));
                lista.add(c);
            }
        } catch (SQLException e) {
            throw new SQLException("Erro ao buscar contra-cheques: " + e.getMessage(), e);
        } finally {
            this.desconectar();
        }
        return lista;
    }

    /**
     * Insere ou atualiza um contra-cheque na tabela.
     * Se o objeto tiver id=0, faz INSERT e obtém o generated key.
     * Caso contrário, faz UPDATE.
     */
    public boolean gravar(ContraCheque c) {
        try {
            this.conectar();
            String sql;
            PreparedStatement pstm;

            if (c.getIdContraCheque() == 0) {
                sql = "INSERT INTO contra_cheque " +
                      "(valorBruto, descontos, valorLiquido, funcionario_idFfuncionario, mes, ano) " +
                      "VALUES (?, ?, ?, ?, ?, ?)";
                pstm = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
                pstm.setInt(5, c.getMes());
                pstm.setInt(6, c.getAno());
                pstm.executeUpdate();

                // captura o ID gerado pelo auto_increment
                ResultSet rs = pstm.getGeneratedKeys();
                if (rs.next()) {
                    c.setIdContraCheque(rs.getInt(1));
                }
            } else {
                sql = "UPDATE contra_cheque SET " +
                      "valorBruto=?, descontos=?, valorLiquido=?, funcionario_idFfuncionario=?, mes=?, ano=? " +
                      "WHERE idContra_cheque=?";
                pstm = conn.prepareStatement(sql);
                pstm.setBigDecimal(1, c.getValorBruto());
                pstm.setBigDecimal(2, c.getDescontos());
                pstm.setBigDecimal(3, c.getValorLiquido());
                pstm.setInt(4, c.getFuncionarioId());
                pstm.setInt(5, c.getMes());
                pstm.setInt(6, c.getAno());
                pstm.setInt(7, c.getIdContraCheque());
                pstm.executeUpdate();
            }

            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao gravar: " + e);
            return false;
        }
    }

    /**
     * Carrega um contra-cheque pelo seu ID, trazendo também o nome do funcionário.
     */
    public ContraCheque getCarregaPorID(int idContraCheque) throws Exception {
        ContraCheque c = new ContraCheque();
        String sql = "SELECT c.*, f.nome AS nomeFuncionario " +
                     "FROM contra_cheque c " +
                     "JOIN funcionario f ON f.idFfuncionario = c.funcionario_idFfuncionario " +
                     "WHERE c.idContra_cheque = ?";

        this.conectar();
        PreparedStatement pstm = conn.prepareStatement(sql);
        pstm.setInt(1, idContraCheque);
        ResultSet rs = pstm.executeQuery();

        if (rs.next()) {
            c.setIdContraCheque(rs.getInt("idContra_cheque"));
            c.setValorBruto(rs.getBigDecimal("valorBruto"));
            c.setDescontos(rs.getBigDecimal("descontos"));
            c.setValorLiquido(rs.getBigDecimal("valorLiquido"));
            c.setFuncionarioId(rs.getInt("funcionario_idFfuncionario"));
            c.setMes(rs.getInt("mes"));
            c.setAno(rs.getInt("ano"));
            c.setNomeFuncionario(rs.getString("nomeFuncionario"));
        }

        this.desconectar();
        return c;
    }

    /**
     * Exclui um contra-cheque: remove primeiro eventos e impostos associados,
     * depois remove o registro de contra_cheque em si.
     */
    public boolean excluir(ContraCheque c) {
        try {
            this.conectar();

            String sqlEventos = "DELETE FROM evento_contra_cheque WHERE idContra_cheque = ?";
            PreparedStatement stmtEventos = conn.prepareStatement(sqlEventos);
            stmtEventos.setInt(1, c.getIdContraCheque());
            stmtEventos.executeUpdate();

            String sqlImpostos = "DELETE FROM contra_cheque_imposto WHERE idContra_cheque = ?";
            PreparedStatement stmtImpostos = conn.prepareStatement(sqlImpostos);
            stmtImpostos.setInt(1, c.getIdContraCheque());
            stmtImpostos.executeUpdate();

            String sqlCC = "DELETE FROM contra_cheque WHERE idContra_cheque = ?";
            PreparedStatement stmtCC = conn.prepareStatement(sqlCC);
            stmtCC.setInt(1, c.getIdContraCheque());
            stmtCC.executeUpdate();

            this.desconectar();
            return true;

        } catch (SQLException e) {
            System.out.println("Erro ao excluir contra-cheque: " + e.getMessage());
            return false;
        }
    }

    /**
     * Retorna o total de benefícios ativos (status = 1) para um funcionário.
     */
    public BigDecimal getTotalBeneficiosAtivos(int funcionarioId) throws Exception {
        this.conectar();
        String sql = 
            "SELECT SUM(fb.valor) AS total " +
            "FROM funcionario_beneficio fb " +
            "JOIN beneficio b ON fb.beneficio_idBeneficio = b.idBeneficio " +
            "WHERE fb.funcionario_idFfuncionario = ? AND b.status = 1";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, funcionarioId);
        ResultSet rs = stmt.executeQuery();

        BigDecimal total = BigDecimal.ZERO;
        if (rs.next()) {
            total = rs.getBigDecimal("total");
            if (total == null) {
                total = BigDecimal.ZERO;
            }
        }

        this.desconectar();
        return total;
    }

    /**
     * Insere um evento de contra-cheque (vencimento ou desconto) na tabela evento_contra_cheque.
     */
    public void registrarEvento(int contraChequeId, String descricao, BigDecimal valor, boolean ehDesconto) throws Exception {
        this.conectar();
        String sql = 
            "INSERT INTO evento_contra_cheque " +
            "(descricao, valor, tipo, idContra_cheque) VALUES (?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, descricao);
        stmt.setBigDecimal(2, valor);
        stmt.setString(3, ehDesconto ? "DESCONTO" : "VENCIMENTO");
        stmt.setInt(4, contraChequeId);
        stmt.execute();
        this.desconectar();
    }

    /**
     * Insere um imposto de contra-cheque na tabela contra_cheque_imposto.
     */
    public void registrarImposto(int contraChequeId, int idImposto, BigDecimal valor) throws Exception {
        this.conectar();
        String sql = 
            "INSERT INTO contra_cheque_imposto " +
            "(idContra_cheque, idImposto, valorDescontado) VALUES (?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, contraChequeId);
        stmt.setInt(2, idImposto);
        stmt.setBigDecimal(3, valor);
        stmt.execute();
        this.desconectar();
    }

    /**
     * Retorna a lista de eventos (vencimentos e descontos) associados a um contra-cheque.
     */
    public List<EventoContraCheque> getEventosPorContraCheque(int contraChequeId) throws Exception {
        this.conectar();
        List<EventoContraCheque> lista = new ArrayList<>();
        String sql = "SELECT * FROM evento_contra_cheque WHERE idContra_cheque = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, contraChequeId);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            EventoContraCheque e = new EventoContraCheque();
            e.setDescricao(rs.getString("descricao"));
            e.setValor(rs.getBigDecimal("valor"));
            e.setEhDesconto("DESCONTO".equalsIgnoreCase(rs.getString("tipo")));
            lista.add(e);
        }

        this.desconectar();
        return lista;
    }

    /**
     * Retorna a lista de impostos cadastrados para um dado contra-cheque (unidos à tabela imposto).
     */
    public List<Imposto> getImpostosPorContraCheque(int contraChequeId) throws Exception {
        this.conectar();
        String sql = 
            "SELECT i.*, cci.valorDescontado " +
            "FROM contra_cheque_imposto cci " +
            "JOIN imposto i ON i.idImposto = cci.idImposto " +
            "WHERE cci.idContra_cheque = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, contraChequeId);
        ResultSet rs = stmt.executeQuery();

        List<Imposto> lista = new ArrayList<>();
        while (rs.next()) {
            Imposto i = new Imposto();
            i.setIdImposto(rs.getInt("idImposto"));
            i.setDescricao(rs.getString("descricao"));
            i.setTipo(rs.getString("tipo"));
            i.setFaixaInicio(rs.getBigDecimal("faixaInicio"));
            i.setFaixaFim(rs.getBigDecimal("faixaFim"));
            i.setAliquota(rs.getBigDecimal("aliquota"));
            i.setParcelaDeduzir(rs.getBigDecimal("parcelaDeduzir"));
            i.setValorDescontado(rs.getBigDecimal("valorDescontado"));
            lista.add(i);
        }

        this.desconectar();
        return lista;
    }

    /**
     * Gera um novo contra-cheque para o funcionário, no mês e ano indicados.
     * Cálculos:
     *   - Salário-base: obtido de PagamentoDAO.getUltimoSalario(...)
     *   - Horas esperadas: HorasUtils.calcularHorasEsperadasMes(...)
     *   - Se faltas: calcula desconto = valorHora * (horasEsperadas - horasTrabalhadas)
     *   - Se horas extras: calcula adicional = valorHora * 1.5 * (horasTrabalhadas - horasEsperadas)
     *   - Benefícios ativos: soma de todos os fb.valor onde fb.status=1
     *   - Para cada imposto (INSS, IRRF): calculaValorImposto(...), registra em contra_cheque_imposto e evento_contra_cheque
     *   - Re-grava descontos e valor líquido após somar totalImpostos.
     *
     * Foi ajustado para:
     *   1) ler todos os registros de "imposto" em memória primeiro (List<Imposto>),
     *   2) só depois, iterar essa lista e chamar registrarImposto(...) e registrarEvento(...)
     * para não fechar o ResultSet antes de terminar a iteração.
     */
    public boolean gerarContraCheque(int funcionarioId, int ano, int mes, boolean trabalhaSabado, double horasTrabalhadas) throws Exception {
        // 1) busca salário-base atual
        PagamentoDAO pDAO = new PagamentoDAO();
        BigDecimal salarioBase = BigDecimal.valueOf(pDAO.getUltimoSalario(funcionarioId));

        // 2) feriados do DF no ano
        List<LocalDate> feriados = FeriadoUtils.buscarFeriadosRelevantes(ano, "DF");

        // 3) calcula horas esperadas no mês (inclui sábados se trabalhaSabado=true)
        double horasEsperadas = HorasUtils.calcularHorasEsperadasMes(ano, mes, feriados, trabalhaSabado);

        // 4) calcula valor da hora
        BigDecimal valorHora = salarioBase
                .divide(BigDecimal.valueOf(horasEsperadas), 2, BigDecimal.ROUND_HALF_UP);

        // 5) calcula desconto ou adicional
        BigDecimal desconto = BigDecimal.ZERO;
        BigDecimal adicional = BigDecimal.ZERO;

        if (horasTrabalhadas < horasEsperadas) {
            double dif = horasEsperadas - horasTrabalhadas;
            desconto = valorHora.multiply(BigDecimal.valueOf(dif));
        } else if (horasTrabalhadas > horasEsperadas) {
            double extra = horasTrabalhadas - horasEsperadas;
            adicional = valorHora
                    .multiply(BigDecimal.valueOf(1.5))
                    .multiply(BigDecimal.valueOf(extra));
        }

        // 6) obtém benefícios ativos
        BigDecimal beneficios = getTotalBeneficiosAtivos(funcionarioId);

        // 7) soma vencimentos = salárioBase + adicional + benefícios
        BigDecimal vencimentos = salarioBase.add(adicional).add(beneficios);

        // 8) valor líquido inicial = vencimentos - desconto
        BigDecimal valorLiquido = vencimentos.subtract(desconto);

        // 9) monta objeto ContraCheque e grava pela primeira vez (c/ descontos sem impostos)
        ContraCheque c = new ContraCheque();
        c.setFuncionarioId(funcionarioId);
        c.setValorBruto(salarioBase);
        c.setDescontos(desconto);
        c.setValorLiquido(valorLiquido);
        c.setMes(mes);
        c.setAno(ano);

        boolean ok = this.gravar(c); // aqui já insere na tabela e define c.idContraCheque

        if (ok) {
            // 10) registra eventos (Salário base, Hora extra, Benefícios, Desconto por faltas)
            registrarEvento(c.getIdContraCheque(), "Salário base", salarioBase, false);

            if (adicional.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Hora extra (50%)", adicional, false);
            }
            if (beneficios.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Benefícios", beneficios, false);
            }
            if (desconto.compareTo(BigDecimal.ZERO) > 0) {
                registrarEvento(c.getIdContraCheque(), "Desconto por faltas", desconto, true);
            }

            // 11) BUSCA todos os impostos (INSS, IRRF) em memória antes de inserir
            this.conectar();
            String sql = "SELECT * FROM imposto WHERE tipo IN ('INSS', 'IRRF')";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            List<Imposto> listaImpostos = new ArrayList<>();
            while (rs.next()) {
                Imposto i = new Imposto();
                i.setIdImposto(rs.getInt("idImposto"));
                i.setDescricao(rs.getString("descricao"));
                i.setTipo(rs.getString("tipo"));
                i.setFaixaInicio(rs.getBigDecimal("faixaInicio"));
                i.setFaixaFim(rs.getBigDecimal("faixaFim"));
                i.setAliquota(rs.getBigDecimal("aliquota"));
                i.setParcelaDeduzir(rs.getBigDecimal("parcelaDeduzir"));
                listaImpostos.add(i);
            }
            this.desconectar();

            // 12) itera a lista em memória e só depois chama registrarImposto e registrarEvento
            BigDecimal totalImpostos = BigDecimal.ZERO;
            for (Imposto i : listaImpostos) {
                BigDecimal valorImp = calcularValorImposto(i, salarioBase);
                if (valorImp.compareTo(BigDecimal.ZERO) > 0) {
                    registrarImposto(c.getIdContraCheque(), i.getIdImposto(), valorImp);
                    registrarEvento(c.getIdContraCheque(), i.getDescricao(), valorImp, true);
                    totalImpostos = totalImpostos.add(valorImp);
                }
            }

            // 13) atualiza descontos (já somando totalImpostos) e recalcula valor líquido
            c.setDescontos(c.getDescontos().add(totalImpostos));
            c.setValorLiquido(vencimentos.subtract(c.getDescontos()));
            this.gravar(c); // faz um UPDATE para armazenar descontos finais e valorLiquido finais
        }

        return ok;
    }

    /**
     * Calcula o valor de imposto para um dado "imposto" baseado na base salarial.
     * Se a base estiver dentro da faixa, faz base * aliquota - parcelaDeduzir.
     */
    public BigDecimal calcularValorImposto(Imposto imposto, BigDecimal base) {
        if (base.compareTo(imposto.getFaixaInicio()) >= 0 &&
            (imposto.getFaixaFim() == null || base.compareTo(imposto.getFaixaFim()) <= 0)) {
            BigDecimal aliquotaFrac = imposto.getAliquota().divide(BigDecimal.valueOf(100));
            return base.multiply(aliquotaFrac).subtract(imposto.getParcelaDeduzir());
        }
        return BigDecimal.ZERO;
    }
}

package model;

import java.time.LocalDate;
import java.util.List;
import utils.FeriadoUtils;

public class TesteFeriado {
    public static void main(String[] args) {
        // Agora só buscamos feriados NACIONAIS e do ESTADO (DF)
        List<LocalDate> feriados = FeriadoUtils.buscarFeriadosRelevantes(2025, "DF");

        System.out.println("Feriados encontrados:");
        for (LocalDate data : feriados) {
            System.out.println(data);
        }
    }
}

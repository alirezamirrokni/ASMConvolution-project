//Student: Alireza Mirrokni (student number: 401106617)
//Instructor: Prof. Jahangir
//Sharif University Of Technology
//Winter 2024

import java.util.ArrayList;
import java.util.Scanner;

public class MultiplyMatrices {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<ArrayList<Double>> matrix1 = new ArrayList<>();
        ArrayList<ArrayList<Double>> matrix2 = new ArrayList<>();
        ArrayList<ArrayList<Double>> productMatrix;
        int n, m, k;
        long startTime, endTime, executionTime;

        n = scanner.nextInt();
        k = scanner.nextInt();
        for (int i = 0; i < n; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < k; j++) {
                row.add(scanner.nextDouble());
            }
            matrix1.add(row);
        }

        m = scanner.nextInt();
        for (int i = 0; i < k; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < m; j++) {
                row.add(scanner.nextDouble());
            }
            matrix2.add(row);
        }

        startTime = System.nanoTime();
        productMatrix = multiplyMatrices(matrix1, matrix2, n, m, k);
        endTime = System.nanoTime();

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                System.out.print(productMatrix.get(i).get(j));
                System.out.print(" ");
            }
            System.out.println();
        }

        executionTime = (endTime - startTime);
        System.out.println("\nexecution time in nanoseconds:\n " + executionTime);

    }

    private static ArrayList<ArrayList<Double>> multiplyMatrices(ArrayList<ArrayList<Double>> matrix1, ArrayList<ArrayList<Double>> matrix2, int n, int m, int k) {
        ArrayList<ArrayList<Double>> productMatrix = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < m; j++) {
                double sum = 0;
                for (int z = 0; z < k; z++) {
                    sum += matrix1.get(i).get(z) * matrix2.get(z).get(j);
                }
                row.add(sum);
            }
            productMatrix.add(row);
        }

        return productMatrix;
    }
}

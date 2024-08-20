//Student: Alireza Mirrokni (student number: 401106617)
//Instructor: Prof. Jahangir
//Sharif University Of Technology
//Winter 2024

import java.util.ArrayList;
import java.util.Scanner;

public class ConvolutionUsingMatrixMultiplication {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ArrayList<ArrayList<Double>> kernel = new ArrayList<>();
        ArrayList<ArrayList<Double>> matrix = new ArrayList<>();
        ArrayList<ArrayList<Double>> result;
        int n, k;
        long startTime, endTime, executionTime;

        k = scanner.nextInt();
        for (int i = 0; i < k; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < k; j++) {
                row.add(scanner.nextDouble());
            }
            kernel.add(row);
        }

        n = scanner.nextInt();
        for (int i = 0; i < n; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < n; j++) {
                row.add(scanner.nextDouble());
            }
            matrix.add(row);
        }

        startTime = System.nanoTime();
        result = convolution(kernel, matrix, n, k);
        endTime = System.nanoTime();

        for (int i = 0; i < n - k + 1; i++) {
            for (int j = 0; j < n - k + 1; j++) {
                System.out.print(result.get(i).get(j));
                System.out.print(" ");
            }
            System.out.println();
        }

        executionTime = (endTime - startTime);
        System.out.println("\nexecution time in nanoseconds:\n" + executionTime);

    }

    private static ArrayList<ArrayList<Double>> convolution(ArrayList<ArrayList<Double>> kernel, ArrayList<ArrayList<Double>> matrix, int n, int k) {
        ArrayList<ArrayList<Double>> M = new ArrayList<>();
        ArrayList<ArrayList<Double>> v = new ArrayList<>();
        ArrayList<ArrayList<Double>> tempResult = new ArrayList<>();
        ArrayList<ArrayList<Double>> result = new ArrayList<>();
        int t = n - k + 1;
        int minNonZeroColumn = 0;
        int maxNonZeroColumn = n * k;
        int blockRow = 0;
        int counter = 0;

        for (int i = 0; i < t * t; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < n * n; j++) {
                if (j < minNonZeroColumn || j >= maxNonZeroColumn) row.add(0.0);
                else {
                    int I = Math.floorDiv(j - minNonZeroColumn, n);
                    int blockColumn = (j - minNonZeroColumn) % n;
                    if (blockColumn < blockRow || blockColumn >= blockRow + k) row.add(0.0);
                    else row.add(kernel.get(I).get(blockColumn - blockRow));
                }

                counter++;
                if (counter == n * n * t) {
                    counter = 0;
                    minNonZeroColumn += n;
                    maxNonZeroColumn += n;
                }
            }
            M.add(row);

            blockRow++;
            if (blockRow == t) blockRow = 0;
        }

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                ArrayList<Double> row = new ArrayList<>();
                row.add(matrix.get(i).get(j));
                v.add(row);
            }
        }

        tempResult = multiplyMatrices(M, v, t * t, 1, n * n);

        for (int i = 0; i < t; i++) {
            ArrayList<Double> row = new ArrayList<>();
            for (int j = 0; j < t; j++) {
                row.add(tempResult.get(i * t + j).get(0));
            }
            result.add(row);
        }

        return result;

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

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;

public class IntListsDifferenceSolutionWithoutSet {
    public static void main(String[] args) {
        ArrayList<Integer> first = new ArrayList<>(Arrays.asList(1, 3, 3, 4, 6, 5, 4));
        ArrayList<Integer> second = new ArrayList<>(Arrays.asList(6, 3, 5, 2, 2));
        ArrayList<Integer> target = new ArrayList<>();
        
        for (Integer integer : first) {
            if (!second.contains(integer) && !target.contains(integer)) {
                target.addAll(Collections.singleton(integer));
            }
        }
        for (Integer integer : second) {
            if (!first.contains(integer) && !target.contains(integer)) {
                target.addAll(Collections.singleton(integer));
            }
        }
        Collections.sort(target);
        System.out.println(target);
    }
}

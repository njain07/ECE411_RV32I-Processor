void start() {
    int steps = 64 * 1024 * 1024;
    int arr[1024 * 1024];
    int lengthMod = (1024 * 1024) - 1;
    int i;
    double timeTaken;
    for (i = 0; i < steps; i++) {
        arr[(i * 16) & lengthMod]++;
    }
    while (arr[5]);
}

int main(){
    start();
    return 1;
}

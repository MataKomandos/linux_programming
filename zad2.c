#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

int numbers[10];
pthread_mutex_t mutex;

void* thread_function(void* arg) {
    int id = *((int*)arg);
    free(arg); 

    for (int i = id; i < 10; i += 5) {
        if (numbers[i]%2==0){
            if(id % 2 != 0){
        pthread_mutex_lock(&mutex);
        printf("[Wątek %d] Element[%d] = %d\n", id, i, numbers[i]);
        pthread_mutex_unlock(&mutex);
            }
    }
}

    
}

int main() {
    pthread_t threads[5];
    pthread_mutex_init(&mutex, NULL);
    srand(time(NULL));
    for (int i = 0; i < 10; i++) {
        numbers[i] = rand() % 100;
        printf("Main: numbers[%d] = %d\n", i, numbers[i]);
    }

    for (int i = 0; i < 5; i++) {
        int* id = malloc(sizeof(int));
        *id = i;
        if (pthread_create(&threads[i], NULL, thread_function, id) != 0) {
            perror("Błąd pthread_create");
            return 1;
        }
    }

    for (int i = 0; i < 5; i++) {
        pthread_join(threads[i], NULL);
    }
    pthread_mutex_destroy(&mutex);

    return 0;
}
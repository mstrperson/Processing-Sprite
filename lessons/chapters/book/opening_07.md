Restarting a game sounds hard.  You just start it again.

![](screenshots/ch07_Lose.png){width=3.6in}

```java
void mousePressed() {
  if (gameOver || playerWon) {
    restartGame();
  }
}
```

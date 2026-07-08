enum MermaidDirection {
  topDown,
  leftRight,
  bottomTop,
  rightLeft,
}

MermaidDirection directionFromToken(String token) {
  return switch (token.toUpperCase()) {
    'TD' || 'TB' => MermaidDirection.topDown,
    'BT' => MermaidDirection.bottomTop,
    'LR' => MermaidDirection.leftRight,
    'RL' => MermaidDirection.rightLeft,
    _ => MermaidDirection.topDown,
  };
}

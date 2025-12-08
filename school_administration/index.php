<?php
require_once 'config.php';

$total_students = 0;
global $DB_HOST, $DB_USER, $DB_PASS, $DB_NAME;
$conn = get_db_connection($DB_HOST, $DB_USER, $DB_PASS, $DB_NAME); 

if ($conn) {
    $sql = "SELECT COUNT(StudentID) AS count FROM Students";
    $result = $conn->query($sql);
    if ($result && $row = $result->fetch_assoc()) {
        $total_students = $row['count'];
    }
    $conn->close();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Montfort School Dashboard</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="static/styles/base.css">
</head>
<body class="layout-wrapper light-theme">
  
  <?php include 'includes/navbar.php'; ?>

  <div class="layout">
    
    <?php include 'includes/sidebar.php'; ?>

    <div class="content" id="content">
      <div id="dashboard-module" class="module">
        <h2>Welcome, Administrator</h2>
        <p class="subtitle">Here are some quick stats and reports for Montfort School:</p>
        <div class="cards">
          <div class="card"><i class="fa fa-users"></i><h3>Total Students</h3><p><?php echo number_format($total_students); ?> Enrolled</p></div>
          <div class="card"><i class="fa fa-user-tie"></i><h3>Faculty Members</h3><p>85 Active</p></div>
          <div class="card"><i class="fa fa-bus"></i><h3>Transport Vehicles</h3><p>12 Operational</p></div>
          <div class="card"><i class="fa fa-book"></i><h3>Library Books</h3><p>8,500 Available</p></div>
          <div class="card"><i class="fa fa-computer"></i><h3>Computers</h3><p>200 Available</p></div>
          <div class="card"><i class="fa fa-futbol"></i><h3>Sports</h3><p>Teams: 8</p></div>
          <div class="card"><i class="fa fa-building"></i><h3>Buildings</h3><p>5 Blocks</p></div>
          <div class="card"><i class="fa fa-hand-holding-heart"></i><h3>Charity</h3><p>220 people</p></div>
        </div>
      </div>
    </div> 
    
    <div class="overlay" id="overlay"></div>
    <div class="settings-panel" id="settings-panel">
      <div class="settings-header">
        <h3>Settings</h3>
        <button id="settings-close-btn" class="close-btn" aria-label="close settings">&times;</button>
      </div>
      <div class="settings-item theme-toggle">
        <strong>Theme</strong>
        <button id="theme-toggle-btn" class="btn btn-secondary">Switch to Dark</button>
      </div>
      <div class="settings-item">
        <strong>Language</strong>
        <span>English</span>
      </div>
        <div class="settings-item">
      <strong>Notifications</strong>
        <span>Enabled</span>
      </div>
    </div>
  </div>
  <script src="static/scripts/base.js"></script>
</body>
</html>
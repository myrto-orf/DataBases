<!-- dashboard.php -->
<?php
session_start();
// Check if the user is logged in
if (!isset($_SESSION['loggedin'])) {
    header('Location: index.php');
    exit;
}

// Redirect based on privilege
if ($_SESSION['privilege'] == 'admin') {
    header('Location: admin_dashboard.php');
} elseif ($_SESSION['privilege'] == 'cook') {
    header('Location: cook_dashboard.php');
} else {
    echo "Invalid privilege.";
}
?>

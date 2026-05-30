-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 26, 2026 at 08:50 AM
-- Server version: 10.3.39-MariaDB-0+deb10u2-log
-- PHP Version: 7.3.31-1~deb10u7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `caed_zone`
--

-- --------------------------------------------------------

--
-- Table structure for table `auctions`
--

CREATE TABLE `auctions` (
  `id` bigint(20) NOT NULL,
  `shop_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `start_price` decimal(10,2) DEFAULT NULL,
  `min_increment` decimal(10,2) DEFAULT NULL,
  `buy_now_price` decimal(10,2) DEFAULT NULL,
  `current_price` decimal(10,2) DEFAULT NULL,
  `current_winner_id` bigint(20) DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `status` enum('scheduled','open','closed','settled','cancelled') DEFAULT 'scheduled',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auctions`
--

INSERT INTO `auctions` (`id`, `shop_id`, `product_id`, `start_price`, `min_increment`, `buy_now_price`, `current_price`, `current_winner_id`, `start_at`, `end_at`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 2, '100.00', '20.00', '1000.00', '320.00', NULL, '2026-05-23 16:17:16', '2026-05-24 16:17:16', 'open', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `bids`
--

CREATE TABLE `bids` (
  `id` bigint(20) NOT NULL,
  `auction_id` bigint(20) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `is_auto_bid` tinyint(1) DEFAULT 0,
  `status` enum('active','outbid','won','refunded') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bids`
--

INSERT INTO `bids` (`id`, `auction_id`, `user_id`, `amount`, `is_auto_bid`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 2, '320.00', 0, 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` bigint(20) NOT NULL,
  `code` varchar(8) DEFAULT NULL,
  `name` varchar(80) DEFAULT NULL,
  `icon_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `code`, `name`, `icon_url`, `created_at`, `updated_at`) VALUES
(1, 'PKM', 'Pokemon', NULL, '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 'OP', 'ONE PIECE', NULL, '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL,
  `order_no` varchar(24) DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `shop_id` bigint(20) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `shipping_fee` decimal(10,2) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `fulfill_type` enum('ship_home','open_live') DEFAULT NULL,
  `payment_method` enum('promptpay_qr','wallet') DEFAULT NULL,
  `status` enum('pending_payment','paid','queue_live','packed','shipped','completed','cancelled') DEFAULT 'pending_payment',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `order_no`, `user_id`, `shop_id`, `subtotal`, `shipping_fee`, `total`, `fulfill_type`, `payment_method`, `status`, `created_at`, `updated_at`) VALUES
(1, 'OD20260522001', 2, 1, '220.00', '40.00', '260.00', 'ship_home', 'promptpay_qr', 'paid', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` bigint(20) NOT NULL,
  `order_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `serial_id` bigint(20) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `serial_id`, `qty`, `unit_price`, `created_at`, `updated_at`) VALUES
(1, 1, 2, 2, 1, '220.00', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` bigint(20) NOT NULL,
  `shop_id` bigint(20) DEFAULT NULL,
  `game_id` bigint(20) DEFAULT NULL,
  `set_id` bigint(20) DEFAULT NULL,
  `name` varchar(160) DEFAULT NULL,
  `type` enum('booster_pack','single_card','box','graded_card') DEFAULT NULL,
  `rarity` enum('common','rare','sr','sar','alt','sec') DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `cover_url` varchar(255) DEFAULT NULL,
  `psa_grade` tinyint(4) DEFAULT NULL,
  `status` enum('active','hidden','sold_out') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `shop_id`, `game_id`, `set_id`, `name`, `type`, `rarity`, `price`, `stock`, `cover_url`, `psa_grade`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 'Pokemon 151 Booster Pack', 'booster_pack', 'rare', '180.00', 100, NULL, NULL, 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 1, 2, 2, 'ONE PIECE OP09 Booster Pack', 'booster_pack', 'sr', '220.00', 50, NULL, NULL, 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `product_serials`
--

CREATE TABLE `product_serials` (
  `id` bigint(20) NOT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `serial_code` varchar(40) DEFAULT NULL,
  `carton_no` varchar(8) DEFAULT NULL,
  `box_no` varchar(8) DEFAULT NULL,
  `pack_no` varchar(8) DEFAULT NULL,
  `status` enum('available','reserved','sold','queue_live','opened','delivered') DEFAULT 'available',
  `owner_user_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_serials`
--

INSERT INTO `product_serials` (`id`, `product_id`, `serial_code`, `carton_no`, `box_no`, `pack_no`, `status`, `owner_user_id`, `created_at`, `updated_at`) VALUES
(1, 1, 'PKM-PK151-C01-B01-P01', 'C01', 'B01', 'P01', 'available', NULL, '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 2, 'OP-OP09-C02-B11-P07', 'C02', 'B11', 'P07', 'available', NULL, '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `sets`
--

CREATE TABLE `sets` (
  `id` bigint(20) NOT NULL,
  `game_id` bigint(20) DEFAULT NULL,
  `code` varchar(20) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sets`
--

INSERT INTO `sets` (`id`, `game_id`, `code`, `name`, `release_date`, `created_at`, `updated_at`) VALUES
(1, 1, 'PK151', 'Pokemon 151', '2025-01-01', '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 2, 'OP09', 'Emperors in the New World', '2025-02-01', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` bigint(20) NOT NULL,
  `owner_user_id` bigint(20) DEFAULT NULL,
  `name` varchar(120) DEFAULT NULL,
  `slug` varchar(120) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `gp_rate` decimal(4,2) DEFAULT 10.00,
  `status` enum('active','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `owner_user_id`, `name`, `slug`, `logo_url`, `description`, `gp_rate`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 'CardZone Official', 'cardzone-official', NULL, NULL, '10.00', 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `display_name` varchar(80) DEFAULT NULL,
  `email` varchar(160) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password_hash` varchar(255) DEFAULT NULL,
  `login_provider` enum('email','line','facebook') DEFAULT 'email',
  `provider_uid` varchar(120) DEFAULT NULL,
  `avatar_url` varchar(255) DEFAULT NULL,
  `membership_tier` enum('bronze','silver','gold','platinum') DEFAULT 'bronze',
  `total_spent` decimal(12,2) DEFAULT 0.00,
  `auction_wins` int(11) DEFAULT 0,
  `role` enum('member','seller','admin') DEFAULT 'member',
  `status` enum('active','suspended') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `display_name`, `email`, `phone`, `password_hash`, `login_provider`, `provider_uid`, `avatar_url`, `membership_tier`, `total_spent`, `auction_wins`, `role`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Panya', 'panya@example.com', '0811111111', NULL, 'email', NULL, NULL, 'gold', '0.00', 0, 'admin', 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 'John TCG', 'john@example.com', '0822222222', NULL, 'email', NULL, NULL, 'silver', '0.00', 0, 'member', 'active', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `wallets`
--

CREATE TABLE `wallets` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `balance` decimal(12,2) DEFAULT 0.00,
  `locked_balance` decimal(12,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wallets`
--

INSERT INTO `wallets` (`id`, `user_id`, `balance`, `locked_balance`, `created_at`, `updated_at`) VALUES
(1, 1, '15000.00', '0.00', '2026-05-23 09:17:16', '2026-05-23 09:17:16'),
(2, 2, '5000.00', '1000.00', '2026-05-23 09:17:16', '2026-05-23 09:17:16');

-- --------------------------------------------------------

--
-- Table structure for table `wallet_transactions`
--

CREATE TABLE `wallet_transactions` (
  `id` bigint(20) NOT NULL,
  `wallet_id` bigint(20) DEFAULT NULL,
  `type` enum('topup','purchase','bid_lock','bid_refund','payout','cashback','buyback') DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `ref_type` varchar(40) DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `promptpay_ref` varchar(60) DEFAULT NULL,
  `status` enum('pending','success','failed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auctions`
--
ALTER TABLE `auctions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_auction_shop` (`shop_id`),
  ADD KEY `fk_auction_product` (`product_id`);

--
-- Indexes for table `bids`
--
ALTER TABLE `bids`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bid_user` (`user_id`),
  ADD KEY `idx_bids_auction_amount` (`auction_id`,`amount`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_no` (`order_no`),
  ADD KEY `fk_order_shop` (`shop_id`),
  ADD KEY `idx_orders_user_status` (`user_id`,`status`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_orderitem_order` (`order_id`),
  ADD KEY `fk_orderitem_product` (`product_id`),
  ADD KEY `fk_orderitem_serial` (`serial_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_shop` (`shop_id`),
  ADD KEY `fk_product_game` (`game_id`),
  ADD KEY `fk_product_set` (`set_id`);

--
-- Indexes for table `product_serials`
--
ALTER TABLE `product_serials`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `serial_code` (`serial_code`),
  ADD KEY `fk_serial_product` (`product_id`),
  ADD KEY `fk_serial_owner` (`owner_user_id`),
  ADD KEY `idx_serial_code` (`serial_code`);

--
-- Indexes for table `sets`
--
ALTER TABLE `sets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_set_game` (`game_id`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_shop_owner` (`owner_user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `wallets`
--
ALTER TABLE `wallets`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_wallet_tx_wallet` (`wallet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auctions`
--
ALTER TABLE `auctions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bids`
--
ALTER TABLE `bids`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product_serials`
--
ALTER TABLE `product_serials`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `sets`
--
ALTER TABLE `sets`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wallets`
--
ALTER TABLE `wallets`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auctions`
--
ALTER TABLE `auctions`
  ADD CONSTRAINT `fk_auction_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_auction_shop` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`);

--
-- Constraints for table `bids`
--
ALTER TABLE `bids`
  ADD CONSTRAINT `fk_bid_auction` FOREIGN KEY (`auction_id`) REFERENCES `auctions` (`id`),
  ADD CONSTRAINT `fk_bid_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_order_shop` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`),
  ADD CONSTRAINT `fk_order_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  ADD CONSTRAINT `fk_orderitem_serial` FOREIGN KEY (`serial_id`) REFERENCES `product_serials` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`),
  ADD CONSTRAINT `fk_product_set` FOREIGN KEY (`set_id`) REFERENCES `sets` (`id`),
  ADD CONSTRAINT `fk_product_shop` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`);

--
-- Constraints for table `product_serials`
--
ALTER TABLE `product_serials`
  ADD CONSTRAINT `fk_serial_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_serial_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `sets`
--
ALTER TABLE `sets`
  ADD CONSTRAINT `fk_set_game` FOREIGN KEY (`game_id`) REFERENCES `games` (`id`);

--
-- Constraints for table `shops`
--
ALTER TABLE `shops`
  ADD CONSTRAINT `fk_shop_owner` FOREIGN KEY (`owner_user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `wallets`
--
ALTER TABLE `wallets`
  ADD CONSTRAINT `fk_wallet_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `wallet_transactions`
--
ALTER TABLE `wallet_transactions`
  ADD CONSTRAINT `fk_wallet_tx_wallet` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

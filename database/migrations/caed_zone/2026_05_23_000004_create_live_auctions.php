<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'caed_zone';

    public function up(): void
    {
        Schema::create('live_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shop_id')->constrained()->cascadeOnDelete();
            $table->string('title', 160);
            $table->enum('platform', ['facebook', 'youtube']);
            $table->string('stream_url', 255)->nullable();
            $table->dateTime('scheduled_at');
            $table->enum('status', ['scheduled', 'live', 'ended'])->default('scheduled');
            $table->timestamps();
        });

        Schema::create('live_queues', function (Blueprint $table) {
            $table->id();
            $table->foreignId('live_session_id')->constrained()->cascadeOnDelete();
            $table->foreignId('order_item_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->unsignedInteger('queue_no');
            $table->foreignId('serial_id')->nullable()->constrained('product_serials')->nullOnDelete();
            $table->enum('status', ['waiting', 'locked', 'opening', 'done'])->default('waiting');
            $table->json('result_cards_json')->nullable();
            $table->boolean('is_priority')->default(false);
            $table->timestamps();

            $table->index(['live_session_id', 'queue_no']);
        });

        Schema::create('auctions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shop_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            $table->decimal('start_price', 10, 2);
            $table->decimal('min_increment', 10, 2)->default(10);
            $table->decimal('buy_now_price', 10, 2)->nullable();
            $table->decimal('current_price', 10, 2);
            $table->foreignId('current_winner_id')->nullable()->constrained('users')->nullOnDelete();
            $table->dateTime('start_at');
            $table->dateTime('end_at');
            $table->enum('status', ['scheduled', 'open', 'closed', 'settled', 'cancelled'])->default('scheduled');
            $table->timestamps();

            $table->index(['status', 'end_at']);
        });

        Schema::create('bids', function (Blueprint $table) {
            $table->id();
            $table->foreignId('auction_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->decimal('amount', 10, 2);
            $table->boolean('is_auto_bid')->default(false);
            $table->foreignId('locked_txn_id')->nullable()->constrained('wallet_transactions')->nullOnDelete();
            $table->enum('status', ['active', 'outbid', 'won', 'refunded'])->default('active');
            $table->timestamps();

            $table->index(['auction_id', 'amount']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bids');
        Schema::dropIfExists('auctions');
        Schema::dropIfExists('live_queues');
        Schema::dropIfExists('live_sessions');
    }
};

<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    protected $connection = 'caed_zone';

    public function up(): void
    {
        Schema::create('collection_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            $table->foreignId('serial_id')->nullable()->constrained('product_serials')->nullOnDelete();
            $table->enum('source', ['opening', 'auction', 'purchase']);
            $table->decimal('est_value', 10, 2)->nullable();
            $table->dateTime('acquired_at');
            $table->timestamps();

            $table->index(['user_id', 'acquired_at']);
        });

        Schema::create('wishlists', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['user_id', 'product_id']);
        });

        Schema::create('psa_submissions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('service_level', ['economy', 'regular', 'express']);
            $table->text('note')->nullable();
            $table->unsignedInteger('qty')->default(1);
            $table->enum('status', ['preparing', 'sent_to_psa', 'grading', 'completed'])->default('preparing');
            $table->timestamps();
        });

        Schema::create('psa_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('submission_id')->constrained('psa_submissions')->cascadeOnDelete();
            $table->foreignId('collection_item_id')->constrained()->cascadeOnDelete();
            $table->unsignedTinyInteger('grade_result')->nullable();
            $table->timestamps();
        });

        Schema::create('buyback_listings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shop_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained()->cascadeOnDelete();
            $table->decimal('buy_price', 10, 2);
            $table->enum('status', ['open', 'closed'])->default('open');
            $table->timestamps();
        });

        Schema::create('buyback_requests', function (Blueprint $table) {
            $table->id();
            $table->foreignId('buyback_listing_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('collection_item_id')->constrained()->cascadeOnDelete();
            $table->decimal('offer_price', 10, 2);
            $table->enum('status', ['pending', 'accepted', 'rejected', 'paid'])->default('pending');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('buyback_requests');
        Schema::dropIfExists('buyback_listings');
        Schema::dropIfExists('psa_items');
        Schema::dropIfExists('psa_submissions');
        Schema::dropIfExists('wishlists');
        Schema::dropIfExists('collection_items');
    }
};

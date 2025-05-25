-- CreateEnum
CREATE TYPE "Blood_type" AS ENUM ('A_positive', 'A_negative', 'B_positive', 'B_negative', 'AB_positive', 'AB_negative', 'O_positive', 'O_negative');

-- CreateEnum
CREATE TYPE "Nature" AS ENUM ('Plaquette', 'CGR', 'PFC');

-- CreateEnum
CREATE TYPE "Status" AS ENUM ('pending', 'approved', 'denied');

-- CreateEnum
CREATE TYPE "Action_type" AS ENUM ('create', 'edit', 'delete');

-- CreateEnum
CREATE TYPE "Target" AS ENUM ('user', 'distributor');

-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "center_id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin" (
    "id" TEXT NOT NULL,
    "center_id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "distributor" (
    "id" TEXT NOT NULL,
    "center_id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "distributor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "center" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "center_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "blood_bag" (
    "id" TEXT NOT NULL,
    "origin" TEXT NOT NULL,
    "current_location" TEXT NOT NULL,
    "phenotype" TEXT NOT NULL,
    "blood_type" "Blood_type" NOT NULL,
    "nature" "Nature" NOT NULL,
    "bag_number" INTEGER NOT NULL,
    "bag_taken_date" TIMESTAMP(3) NOT NULL,
    "volume" INTEGER NOT NULL,
    "expiration_date" TIMESTAMP(3) NOT NULL,
    "donor_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "blood_bag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "donor" (
    "id" TEXT NOT NULL,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "phone_number" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "donor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "request" (
    "id" TEXT NOT NULL,
    "sender_id" TEXT NOT NULL,
    "receiver_id" TEXT NOT NULL,
    "status" "Status" NOT NULL,
    "volume" INTEGER NOT NULL,
    "user_id" TEXT NOT NULL,
    "number_of_bags" INTEGER NOT NULL,
    "blood_type" "Blood_type" NOT NULL,
    "nature" "Nature" NOT NULL,
    "reason_for_disapproval" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "request_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "distribution" (
    "id" TEXT NOT NULL,
    "request_id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "distributor_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "distribution_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "distributed_bag" (
    "distribution_id" TEXT NOT NULL,
    "bag_id" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "admin_log" (
    "id" TEXT NOT NULL,
    "admin_id" TEXT NOT NULL,
    "action_type" "Action_type" NOT NULL,
    "target_type" "Target" NOT NULL,
    "target_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_log" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "bag_id" TEXT NOT NULL,
    "action_type" "Action_type" NOT NULL,
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_log_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- CreateIndex
CREATE UNIQUE INDEX "user_phone_number_key" ON "user"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "admin_center_id_key" ON "admin"("center_id");

-- CreateIndex
CREATE UNIQUE INDEX "admin_username_key" ON "admin"("username");

-- CreateIndex
CREATE UNIQUE INDEX "admin_phone_number_key" ON "admin"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "distributor_phone_number_key" ON "distributor"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "center_name_key" ON "center"("name");

-- CreateIndex
CREATE UNIQUE INDEX "center_address_key" ON "center"("address");

-- CreateIndex
CREATE UNIQUE INDEX "blood_bag_origin_bag_number_key" ON "blood_bag"("origin", "bag_number");

-- CreateIndex
CREATE UNIQUE INDEX "donor_phone_number_key" ON "donor"("phone_number");

-- CreateIndex
CREATE UNIQUE INDEX "distribution_request_id_key" ON "distribution"("request_id");

-- CreateIndex
CREATE UNIQUE INDEX "distributed_bag_distribution_id_bag_id_key" ON "distributed_bag"("distribution_id", "bag_id");

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_center_id_fkey" FOREIGN KEY ("center_id") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin" ADD CONSTRAINT "admin_center_id_fkey" FOREIGN KEY ("center_id") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distributor" ADD CONSTRAINT "distributor_center_id_fkey" FOREIGN KEY ("center_id") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blood_bag" ADD CONSTRAINT "blood_bag_origin_fkey" FOREIGN KEY ("origin") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blood_bag" ADD CONSTRAINT "blood_bag_current_location_fkey" FOREIGN KEY ("current_location") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "blood_bag" ADD CONSTRAINT "blood_bag_donor_id_fkey" FOREIGN KEY ("donor_id") REFERENCES "donor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "request" ADD CONSTRAINT "request_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "request" ADD CONSTRAINT "request_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "request" ADD CONSTRAINT "request_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "center"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distribution" ADD CONSTRAINT "distribution_request_id_fkey" FOREIGN KEY ("request_id") REFERENCES "request"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distribution" ADD CONSTRAINT "distribution_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distribution" ADD CONSTRAINT "distribution_distributor_id_fkey" FOREIGN KEY ("distributor_id") REFERENCES "distributor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distributed_bag" ADD CONSTRAINT "distributed_bag_distribution_id_fkey" FOREIGN KEY ("distribution_id") REFERENCES "distribution"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "distributed_bag" ADD CONSTRAINT "distributed_bag_bag_id_fkey" FOREIGN KEY ("bag_id") REFERENCES "blood_bag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin_log" ADD CONSTRAINT "admin_log_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "admin"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_log" ADD CONSTRAINT "user_log_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_log" ADD CONSTRAINT "user_log_bag_id_fkey" FOREIGN KEY ("bag_id") REFERENCES "blood_bag"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
